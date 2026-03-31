import { TestBed } from '@angular/core/testing';

import { AppNotifService } from './app-notif-service';

describe('AppNotifService', () => {
  let service: AppNotifService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(AppNotifService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
