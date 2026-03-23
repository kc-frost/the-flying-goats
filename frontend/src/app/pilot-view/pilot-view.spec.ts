import { ComponentFixture, TestBed } from '@angular/core/testing';

import { PilotView } from './pilot-view';

describe('PilotView', () => {
  let component: PilotView;
  let fixture: ComponentFixture<PilotView>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [PilotView]
    })
    .compileComponents();

    fixture = TestBed.createComponent(PilotView);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
