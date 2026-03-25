import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SeatSelectorModal } from './seat-selector-modal';

describe('SeatSelectorModal', () => {
  let component: SeatSelectorModal;
  let fixture: ComponentFixture<SeatSelectorModal>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [SeatSelectorModal]
    })
    .compileComponents();

    fixture = TestBed.createComponent(SeatSelectorModal);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
