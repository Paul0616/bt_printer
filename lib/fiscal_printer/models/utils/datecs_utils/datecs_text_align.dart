enum DatecsTextAlign {
  left(0x00),
  right(0x02),
  center(0x01);

  const DatecsTextAlign(this.value);
  final int value;

  // int get value {
  //   switch(this){
  //     case DatecsTextAlign.left:
  //       return 0x00;
  //     case DatecsTextAlign.right:
  //       return 0x02;
  //     case DatecsTextAlign.center:
  //       return 0x01;
  //     default:
  //       return 0x00;
  //   }
  // }
}
