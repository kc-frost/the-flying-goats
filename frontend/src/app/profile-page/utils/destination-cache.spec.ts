import { TestBed } from '@angular/core/testing';

import { DestinationCache } from './destination-cache';

describe('DestinationCache', () => {
  let service: DestinationCache;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(DestinationCache);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
