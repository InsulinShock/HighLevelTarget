//
// Prerelease License - for engineering feedback and testing purposes
// only. Not for sale.
//
// File: ert_main.cpp
//
// Code generated for Simulink model 'model0'.
//
// Model version                  : 1.13
// Simulink Coder version         : 9.3 (R2020a) 18-Nov-2019
// C/C++ source code generated on : Mon Dec 23 09:03:17 2019
//
// Target selection: ert.tlc
// Embedded hardware selection: Intel->x86-64 (Windows64)
// Code generation objectives: Unspecified
// Validation result: Not run
//
#include <stdio.h>                // This ert_main.c example uses printf/fflush
#include "model0.h"                    // Model's header file
#include "rtwtypes.h"
#include "stddef.h"

static model0ModelClass model0_Obj;

//
// Example use case for call to exported function:
// model0_Obj.fun
//
extern void sample_usage_fun(void);
void sample_usage_fun(void)
{
  //
  //  Set task inputs here:


  //
  //  Call to exported function

  model0_Obj.fun();

  //
  //  Read function outputs here

}

//
// The example "main" function illustrates what is required by your
// application code to initialize, execute, and terminate the generated code.
// Attaching exported functions to a real-time clock is target specific.
// This example illustrates how you do this relative to initializing the model.
//
int_T main(int_T argc, const char *argv[])
{
  // Unused arguments
  (void)(argc);
  (void)(argv);

  // Initialize model
  model0_Obj.initialize();
  while (rtmGetErrorStatus(model0_Obj.getRTM()) == (NULL)) {
    //  Perform application tasks here.
  }

  // Terminate model
  model0_Obj.terminate();
  return 0;
}

//
// File trailer for generated code.
//
// [EOF]
//
