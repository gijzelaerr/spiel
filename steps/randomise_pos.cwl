cwlVersion: v1.0
class: ExpressionTool



requirements:
  - class: InlineJavascriptRequirement



inputs:
  ra_in:
    type: float?
    default: 0

  dec_in:
    type: float?
    default: -30

  randomise_pos:
    type: boolean?
    default: false


outputs:
  ra:
    type: float
  dec:
    type: float

expression: |
  ${
     if (inputs.randomise_pos) {
        var max = 0.0;
        var min = -90.0;
        var dec = (Math.random() * (max - min)) + min;
        var ra = inputs.ra_in;
     } else {
        var ra =  inputs.ra_in;
        var dec = inputs.dec_in;
     };

     return {
        "ra": ra,
        "dec": dec
     };

  };