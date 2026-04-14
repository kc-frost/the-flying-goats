import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ReservationOverride } from './reservation-override';

describe('ReservationOverride', () => {
  let component: ReservationOverride;
  let fixture: ComponentFixture<ReservationOverride>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [ReservationOverride]
    })
    .compileComponents();

    fixture = TestBed.createComponent(ReservationOverride);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
