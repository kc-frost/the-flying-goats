import { AbstractControl, ValidationErrors, ValidatorFn } from "@angular/forms";

export function invalidDateValidator(control: AbstractControl): ValidationErrors | null {
  const departureDate = new Date(control.get("departureDate")?.value);
  const arrivalDate = new Date(control.get("arrivalDate")?.value);
  const currentDate = new Date();

  if (departureDate < currentDate) {
    return { departBeforeToday: true };
  }

  if (arrivalDate < currentDate) {
    return { arriveBeforeToday: true };
  }

  if (departureDate > arrivalDate) {
    return { leaveAfterArrive: true };
  }

  return null;
}
