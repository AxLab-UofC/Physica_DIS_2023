void parameter_gui() {
  cp5 = new ControlP5(this);

  // environment partameters group
  Group g1 = cp5.addGroup("environment parammeter")
    .setBackgroundColor(color(255, 255))
    .setBackgroundHeight(80)
    ;

  // interaction technique group
  Group g2 = cp5.addGroup("interaction technique")
    .setBackgroundColor(color(255, 255))
    .setBackgroundHeight(100)
    ;

  // group number 1, contains 2 bangs
  Group g3 = cp5.addGroup("Object Graphic")
    .setBackgroundColor(color(255, 255))
    .setBackgroundHeight(200)
    ;

  // group number 1, contains 2 bangs
  Group g4 = cp5.addGroup("Motion")
    .setBackgroundColor(color(255, 255))
    .setBackgroundHeight(200)
    ;

  cp5.addSlider("gravity")
    .setPosition(40, 60)
    .setColorLabel(color(0))
    .setSize(100, 20)
    .setRange(0, 100)
    .setValue(30)
    .moveTo(g1);


  checkbox = cp5.addCheckBox("checkBox")
    .setPosition(40, 40)
    .setColorLabel(color(0))
    .setSize(20, 20)
    .setItemsPerRow(1)
    .setSpacingColumn(30)
    .setSpacingRow(20)
    .addItem("Throw", 0)
    .moveTo(g2)
    ;


  checkbox2 = cp5.addCheckBox("checkBox2")
    .setColorLabel(color(0))
    .setPosition(40, 60)
    .setSize(20, 20)
    .setItemsPerRow(1)
    .setSpacingColumn(30)
    .setSpacingRow(20)
    .addItem("Show particle", 50)
    .addItem("Show object path", 100)
    .addItem("Show object position", 100)
    .moveTo(g3)
    ;

  checkbox3 = cp5.addCheckBox("checkBox3")
    .setColorLabel(color(0))
    .setPosition(40, 40)
    .setSize(20, 20)
    .setItemsPerRow(1)
    .setSpacingColumn(30)
    .setSpacingRow(20)
    .addItem("Object velocity", 0)
    .addItem("Particle velocity", 50)
    .addItem("Object velocity - x", 100)
    .addItem("Object velocity - y", 150)
    .moveTo(g4)
    ;


  accordion = cp5.addAccordion("acc")
    .setPosition(1600, 500)
    .setWidth(200)
    .addItem(g1)
    .addItem(g2)
    .addItem(g3)
    .addItem(g4)
    ;
  accordion.open(0,1,2, 3);

}
