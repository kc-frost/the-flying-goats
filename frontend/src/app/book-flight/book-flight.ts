import {ChangeDetectionStrategy, Component} from '@angular/core';
import {JsonPipe} from '@angular/common';
import {FormControl, FormGroup, FormsModule, ReactiveFormsModule} from '@angular/forms';
import {provideNativeDateAdapter} from '@angular/material/core';
import {MatDatepickerModule} from '@angular/material/datepicker';
import {MatFormFieldModule} from '@angular/material/form-field';
import {MatInputModule} from '@angular/material/input';
import {MatSelectModule} from '@angular/material/select';
import {MatButtonModule} from '@angular/material/button';

@Component({
  selector: 'app-book-flight',
  templateUrl: './book-flight.html',
  styleUrl: './book-flight.css',
  providers: [provideNativeDateAdapter()],
  imports: [MatFormFieldModule, MatDatepickerModule, FormsModule, ReactiveFormsModule, JsonPipe, MatFormFieldModule, MatSelectModule, MatInputModule, FormsModule, MatButtonModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class BookFlight {
  readonly range = new FormGroup({
    start: new FormControl<Date | null>(null),
    end: new FormControl<Date | null>(null),
  });

  origins = [
    {
      value: 'aus-0', viewValue: 'Austin',
    }
  ]
  cities = [
    {value: 'jpn-0', viewValue: 'Japan'},
    {value: 'prs-1', viewValue: 'Paris'},
    {value: 'nyc-2', viewValue: 'New York'},
  ];

  selectedDest!: string;

  jp_flights = [
    { value: 'jpf-1', viewValue: 'JP123'},
    { value: 'jpf-2', viewValue: 'AS231'},
    { value: 'jpf-3', viewValue: 'HK348'},
  ]
}
