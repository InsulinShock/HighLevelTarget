//
// Prerelease License - for engineering feedback and testing purposes
// only. Not for sale.
//
// File: model.cpp
//
// Code generated for Simulink model 'model'.
//
// Model version                  : 1.6
// Simulink Coder version         : 9.3 (R2020a) 18-Nov-2019
// C/C++ source code generated on : Thu Jan  9 18:07:46 2020
//
// Target selection: ert.tlc
// Embedded hardware selection: MyManufacturer->MyDevice
// Code generation objectives: Unspecified
// Validation result: Not run
//
#include "model.h"
#include "model_private.h"

// Model step function
void modelModelClass::step()
{
  // (no output/update code required)
}

// Model initialize function
void modelModelClass::initialize()
{
  // (no initialization code required)
}

// Model terminate function
void modelModelClass::terminate()
{
  // (no terminate code required)
}

// Constructor
modelModelClass::modelModelClass() : model_M()
{
  // Currently there is no constructor body generated.
}

// Destructor
modelModelClass::~modelModelClass()
{
  // Currently there is no destructor body generated.
}

// Real-Time Model get method
modelModelClass::RT_MODEL_model_T * modelModelClass::getRTM()
{
  return (&model_M);
}

//
// File trailer for generated code.
//
// [EOF]
//
