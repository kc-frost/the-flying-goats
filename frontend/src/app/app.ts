import { Component, signal, inject } from '@angular/core';
import { RouterOutlet, RouterLink, Router } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { AuthService } from './_shared/services/auth-service';
import { UserService } from './_shared/services/user-service';
import { OnInit } from '@angular/core';
import { AppNotifService } from './_shared/services/app-notif-service';
import { AsyncPipe } from '@angular/common';
import { environment } from '../_environments/environment';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, RouterLink, AsyncPipe],
  templateUrl: './app.html',
  // I added this cause my styles weren't applying
  styleUrls: ['./app.css'],
})

export class App implements OnInit {
  protected readonly title = signal('tfg');
  private router = inject(Router);
  private http = inject(HttpClient);
  private appNotifs = inject(AppNotifService);
  authService = inject(AuthService);
  userService = inject(UserService);

  ngOnInit() {
    this.appNotifs.startAlerts();

    this.authService.setCurrentAfterRefresh().subscribe({
      error: (err) => {
        console.log("CHECK-SESSION FAILED:", err);
      }
    });

    // Epilepsy local storage check. This way, it's per user, and persists across sessions so long as it's enabled
    this.epilepsyMode.set(localStorage.getItem("funWheelEpilepsyMode") === "true");
  }

  defaultImg = "/header/profile-dropdown/profile-dropdown.svg";
  clickedImg = "/header/profile-dropdown/profile-dropdown-hover.svg";
  
  isExpanded: boolean = false;
  toggleExpanded() {
    this.isExpanded = !this.isExpanded;
    return this.isExpanded;
  }

  // If a session exists, clicking on the profile picture should also show ProfileDropdown
  // Otherwise (including errors), show Login
  handleProfileClick() {
    if (this.authService.getAuthenticated()) {
      this.navigateToProfile()
    } else {
      this.navigateToLogin();
    }
  }

  navigateToLogin() {
    this.router.navigate([{ outlets: 
      { dropdown: ['login']}}],
      {
        skipLocationChange: true
      }
    )
  }

  navigateToProfile() {
    this.router.navigate([{ outlets: 
      { dropdown: ['profile-page'] } }], 
    {
      skipLocationChange: true
    });
  }

  // FUN WHEEL STUFF
  showWheelModal = signal(false);
  isWheelSpinning = signal(false);
  showBadWind = signal(false);
  wheelRotation = signal(0);
  wheelResult = signal("Waiting for chaos.");
  epilepsyMode = signal(false);
  wheelTimers: ReturnType<typeof setTimeout>[] = [];

  wheelOptions = [
    { label: "Delete account!", outcome: "delete-account", labelAngle: 22.5, startDegree: 0, endDegree: 45 },
    { label: "Free flights for life!", outcome: "free-flights", labelAngle: 67.5, startDegree: 45, endDegree: 90 },
    { label: "Epilepsy mode! (not really)", outcome: "epilepsy-mode", labelAngle: 112.5, startDegree: 90, endDegree: 135 },
    { label: "Become an Admin!", outcome: "become-admin", labelAngle: 157.5, startDegree: 135, endDegree: 180 },
    { label: "Become a Pilot!", outcome: "become-pilot", labelAngle: 202.5, startDegree: 180, endDegree: 225 },
    { label: "Demoted!", outcome: "demotion", labelAngle: 247.5, startDegree: 225, endDegree: 270 },
    { label: "Surprise pick!", outcome: "surprise-pick", labelAngle: 292.5, startDegree: 270, endDegree: 315 },
    { label: "Cancel all your reservations", outcome: "cancel-reservations", labelAngle: 337.5, startDegree: 315, endDegree: 360 }
  ];

  openWheelModal() {
    this.showWheelModal.set(true);
    this.isWheelSpinning.set(false);
    this.showBadWind.set(false);
    this.wheelResult.set("Try your luck!");
  }

  closeWheelModal() {
    this.clearWheelTimers();
    this.showWheelModal.set(false);
    this.isWheelSpinning.set(false);
    this.showBadWind.set(false);
    this.wheelResult.set("Try your luck!");
  }

  spinWheel() {
    if (this.isWheelSpinning()) {
      return;
    }

    this.clearWheelTimers();

    const landingDegree = this.getRandomLandingDegree();
    const selectedIndex = this.getWheelOptionIndexForDegree(landingDegree);

    this.isWheelSpinning.set(true);
    this.showBadWind.set(false);
    this.wheelResult.set("Spinning...");

    this.addWheelTimer(() => {
      this.spinToDegree(landingDegree, 6);
    }, 0);

    if (selectedIndex === 1) {
      this.addWheelTimer(() => {
        this.showBadWind.set(true);
        this.wheelResult.set("Oh nooooo it's really windy today!");
      }, 3200);

      this.addWheelTimer(() => {
        this.spinToDegree(this.getRandomLandingDegreeForIndex(0), 2);
      }, 4100);

      this.addWheelTimer(() => {
        this.finishWheelResult(0);
      }, 7400);
    } else {
      this.addWheelTimer(() => {
        this.finishWheelResult(selectedIndex);
      }, 3500);
    }
  }

  getRandomLandingDegree() {
    return Math.random() * 360;
  }

  getRandomLandingDegreeForIndex(index: number) {
    const option = this.wheelOptions[index];
    return option.startDegree + Math.random() * (option.endDegree - option.startDegree);
  }

  getWheelOptionIndexForDegree(degree: number) {
    const normalizedDegree = ((degree % 360) + 360) % 360;
    const selectedIndex = this.wheelOptions.findIndex(option =>
      normalizedDegree >= option.startDegree && normalizedDegree < option.endDegree
    );

    return selectedIndex === -1 ? this.wheelOptions.length - 1 : selectedIndex;
  }

  spinToDegree(degree: number, extraTurns: number = 5) {
    const nextFullTurn = Math.ceil(this.wheelRotation() / 360) * 360;

    this.wheelRotation.set(nextFullTurn + extraTurns * 360 + (360 - degree));
  }

  finishWheelResult(index: number) {
    this.isWheelSpinning.set(false);
    this.showBadWind.set(false);
    this.applyWheelResult(index);
  }

  getWheelResultText(index: number) {
    if (index === 0) {
      return "Delete account! Frontend only for now tho, you're safe... for now...";
    }

    return this.wheelOptions[index].label;
  }

  applyWheelResult(index: number) {
    const option = this.getFinalWheelOption(index);

    if (option.outcome === "epilepsy-mode") {
      const nextMode = !this.epilepsyMode();
      this.epilepsyMode.set(nextMode);
      localStorage.setItem("funWheelEpilepsyMode", String(nextMode));
      this.wheelResult.set(option.label);
      return;
    }

    const backendOutcome = option.outcome === "free-flights" ? "delete-account" : option.outcome;

    this.http.post<{ message: string, loggedOut?: boolean }>(
      `${environment.api_url}/api/fun-wheel/outcome`,
      { outcome: backendOutcome }
    ).subscribe({
      next: (res) => {
        this.wheelResult.set(res.message);

        if (res.loggedOut) {
          this.authService.reset();
          this.userService.reset();
          this.router.navigate(["/"]);
          return;
        }

        // Update after something like becoming an admin or pilot
        this.authService.setCurrentAfterRefresh().subscribe({
          error: (err) => console.log("CHECK-SESSION FAILED:", err)
        });
      },
      error: (err) => {
        this.wheelResult.set(err.error?.message || "Something happened???");
      }
    });
  }

  getFinalWheelOption(index: number) {
    const option = this.wheelOptions[index];

    if (option.outcome !== "surprise-pick") {
      return option;
    }

    const surpriseOptions = this.wheelOptions.filter(wheelOption => wheelOption.outcome !== "surprise-pick");
    const surpriseOption = surpriseOptions[Math.floor(Math.random() * surpriseOptions.length)];
    return surpriseOption;
  }

  isHomeRoute() {
    return this.router.url === "/" || this.router.url === "" || this.router.url.startsWith("/(");
  }

  addWheelTimer(callback: () => void, delay: number) {
    const timer = setTimeout(callback, delay);
    this.wheelTimers.push(timer);
  }

  clearWheelTimers() {
    this.wheelTimers.forEach(timer => clearTimeout(timer));
    this.wheelTimers = [];
  }

  // END OF FUN WHEEL STUFF
}
