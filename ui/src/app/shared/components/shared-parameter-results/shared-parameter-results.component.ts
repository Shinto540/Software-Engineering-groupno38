import { Component, Input, OnInit } from "@angular/core";
import { groupBy } from "lodash";

@Component({
  selector: "app-shared-parameter-results",
  templateUrl: "./shared-parameter-results.component.html",
  styleUrls: ["./shared-parameter-results.component.scss"],
})
export class SharedParameterResultsComponent implements OnInit {
  @Input() order: any;
  @Input() parameter: any;
  @Input() count: number;

  parameterResultsDetails: any;
  constructor() {}

  ngOnInit(): void {
    this.order = {
      ...this.order,
      testAllocations:
        this.order?.testAllocations?.filter(
          (allocation) =>
            allocation?.concept?.uuid === this.parameter?.uuid &&
            allocation?.results?.length > 0
        ) || [],
      allocationsGroupedByParameter: groupBy(
        (
          this.order?.testAllocations?.filter(
            (allocation) =>
              allocation?.concept?.uuid === this.parameter?.uuid &&
              allocation?.results?.length > 0
          ) || []
        )?.map((allocation) => {
          return {
            ...allocation,
            parameterUuid: allocation?.concept?.uuid,
          };
        }),
        "parameterUuid"
      ),
    };
    // console.log(this.order);
    // console.log(this.parameter);
    // console.log(this.count);
    this.parameterResultsDetails =
      this.order?.allocationsGroupedByParameter[this.parameter?.uuid];
  }
}
