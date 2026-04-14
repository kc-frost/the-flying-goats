import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ViewCancellations } from './view-cancellations';

describe('ViewCancellations', () => {
  let component: ViewCancellations;
  let fixture: ComponentFixture<ViewCancellations>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [ViewCancellations]
    })
    .compileComponents();

    fixture = TestBed.createComponent(ViewCancellations);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
