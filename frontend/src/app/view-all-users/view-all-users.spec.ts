import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ViewAllUsers } from './view-all-users';

describe('ViewAllUsers', () => {
  let component: ViewAllUsers;
  let fixture: ComponentFixture<ViewAllUsers>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [ViewAllUsers]
    })
    .compileComponents();

    fixture = TestBed.createComponent(ViewAllUsers);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
