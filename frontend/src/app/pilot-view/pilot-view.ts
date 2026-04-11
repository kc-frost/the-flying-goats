import { HttpClient } from "@angular/common/http";
import { Component, inject, OnInit } from "@angular/core";
import { FormsModule, ReactiveFormsModule } from "@angular/forms";
import { CommonModule } from "@angular/common";
import { environment } from "../../_environments/environment";
import { ChangeDetectorRef } from "@angular/core";

type PilotScheduleRow = {
  [key: string]: any;
  isReadOnly: boolean;
};

type CalendarDay = {
  date: Date;
  dayNumber: number;
  dayName: string;
  monthName: string;
  fullLabel: string;
  isToday: boolean;
  events: PilotScheduleRow[];
};

@Component({
  selector: "app-pilot-view",
  standalone: true,
  imports: [ReactiveFormsModule, FormsModule, CommonModule],
  templateUrl: "./pilot-view.html",
  styleUrls: ["./pilot-view.css"],
})
export class PilotView implements OnInit {
  private http = inject(HttpClient);
  private cdr = inject(ChangeDetectorRef);

  pilotSchedule: PilotScheduleRow[] = [];
  calendarDays: CalendarDay[] = [];
  selectedDay: CalendarDay | null = null;

  ngOnInit(): void {
    this.getPilotSchedule();
  }

  pilotName?: string;
  getPilotSchedule(): void {
    this.http
      .get<Omit<PilotScheduleRow, "isReadOnly">[]>(
        `${environment.api_url}/api/pilot-schedule`
      )
      .subscribe({
        next: (rows) => {
          this.pilotSchedule = rows.map((row) => ({
            ...row,
            isReadOnly: true,
          }));

          if (rows.length > 0) {
            const first = rows[0];
            this.pilotName = `${first['fname'] ?? ''} ${first['lname'] ?? ''}`.trim();
          }
          this.buildRollingCalendar();
          this.cdr.detectChanges();
        },
        error: () => {
          alert("Error loading pilot schedule.");
        },
      });
  }

  clearPilotAndFlightAvailability(): void {
    const firstConfirm = confirm(
      "Warning: this will clear old pilot and flight schedule availability data. Not a horribly bad thing, but you'll get in trouble without permission you know. Do you want to continue?"
    );

    if (!firstConfirm) {
      return;
    }

    const secondConfirm = confirm(
      "Final warning: this action is dangerous and IRREVERSIBLE (Unless done manually). Click OK again to permanently continue (You might get fired dawg)."
    );

    if (!secondConfirm) {
      return;
    }

    this.http
      .post(`${environment.api_url}/api/planes/clear-finished`, {})
      .subscribe({
        next: () => {
          alert("Pilot and flight availability was cleared successfully.");
          this.getPilotSchedule();
        },
        error: (err) => {
          console.error(err);
          alert("Error clearing pilot and flight availability.");
        },
      });
  }

  // Rolling calendar, shows the calendar 30 days ahead of the current day so the calendar looks pretty clean.
  // Can't look at the previous days, may add implementation for that later but for now this works.
  buildRollingCalendar(): void {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    this.calendarDays = [];

    for (let i = 0; i < 30; i++) {
      const currentDay = new Date(today);
      currentDay.setDate(today.getDate() + i);

      this.calendarDays.push({
        date: currentDay,
        dayNumber: currentDay.getDate(),
        dayName: currentDay.toLocaleDateString("en-US", { weekday: "short" }),
        monthName: currentDay.toLocaleDateString("en-US", { month: "short" }),
        fullLabel: currentDay.toLocaleDateString("en-US", {
          weekday: "long",
          month: "long",
          day: "numeric",
          year: "numeric",
        }),
        isToday: i === 0,
        events: this.getEventsForDay(currentDay),
      });
    }

    if (!this.selectedDay) {
      this.selectedDay = this.calendarDays[0] ?? null;
    } else {
      const matchingDay = this.calendarDays.find((day) =>
        this.isSameDay(day.date, this.selectedDay!.date)
      );
      this.selectedDay = matchingDay ?? this.calendarDays[0] ?? null;
    }
  }

  getEventsForDay(day: Date): PilotScheduleRow[] {
    return this.pilotSchedule.filter((event) => {
      const eventDate = this.getEventStartDate(event);
      if (!eventDate) {
        return false;
      }

      return this.isSameDay(eventDate, day);
    });
  }

  selectDay(day: CalendarDay): void {
    this.selectedDay = day;
    this.cdr.detectChanges();
  }

  isSameDay(dateOne: Date, dateTwo: Date): boolean {
    return (
      dateOne.getFullYear() === dateTwo.getFullYear() &&
      dateOne.getMonth() === dateTwo.getMonth() &&
      dateOne.getDate() === dateTwo.getDate()
    );
  }

  getSelectedDayEvents(): PilotScheduleRow[] {
    return this.selectedDay?.events ?? [];
  }
  // Changed to account for the change in attributes on the table (schedule used to return datetime, now just date for some reason. Don't remember doing that, but too late to change it)
  // Changing back to datetime like it should've been, suck it old me (leaving the comment above for now cause I think it's funny)
    getEventStartDate(event: PilotScheduleRow): Date | null {
      const rawDateTime = event["liftOff"] ?? event["liftoff"];

      if (!rawDateTime) return null;

      const parsed = new Date(rawDateTime);
      return isNaN(parsed.getTime()) ? null : parsed;
    }

    getEventEndDate(event: PilotScheduleRow): Date | null {
      const rawDateTime = event["landing"];

      if (!rawDateTime) return null;

      const parsed = new Date(rawDateTime);
      return isNaN(parsed.getTime()) ? null : parsed;
    }

  formatEventTime(event: PilotScheduleRow, type: "start" | "end"): string {
    const date =
      type === "start"
        ? this.getEventStartDate(event)
        : this.getEventEndDate(event);

    if (!date) {
      return "N/A";
    }

    return date.toLocaleTimeString("en-US", {
      hour: "numeric",
      minute: "2-digit",
    });
  }

  getPilotName(event: PilotScheduleRow): string {
    const first = event["fname"] ?? event["firstName"] ?? "";
    const last = event["lname"] ?? event["lastName"] ?? "";
    const combined = `${first} ${last}`.trim();

    return combined || event["pilotName"] || event["pilot"] || "Unknown Pilot";
  }

  getFlightCode(event: PilotScheduleRow): string {
    return (
      event["flight"] ??
      event["flightID"] ??
      event["flightNumber"] ??
      event["IATA"] ??
      "No Flight"
    );
  }

  getPlaneCode(event: PilotScheduleRow): string {
    return event["ICAO"] ?? event["planeICAO"] ?? event["plane"] ?? "N/A";
  }

  getOrigin(event: PilotScheduleRow): string {
    return event["origin"] ?? event["departureAirport"] ?? "N/A";
  }

  getDestination(event: PilotScheduleRow): string {
    return event["destination"] ?? event["arrivalAirport"] ?? "N/A";
  }

  getStatus(event: PilotScheduleRow): string {
    return event["status"] ?? event["planeStatus"] ?? "N/A";
  }
}
