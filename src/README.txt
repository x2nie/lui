LUI
===

Lite version of Lazarus GUI (graphical user interface)
Initially, it aim to bring a pure fpGUI into desidned directly 
inside Lazarus

plan:
- store form into *.lfm (instead of code), and load it runtime
- load *.lfm without LResource (LCL)
- no default images (for button's glyph)
- store image inside lfm
- no internal db.
- everything must more similar to Delphi7 than fpGUI.