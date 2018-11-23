--  GPIO pack, using libsimpleio

WITH GPIO.libsimpleio;

PACKAGE BODY GPIO_pack IS

  LED_red	: GPIO.Pin := GPIO.libsimpleio.Create(0, 17, GPIO.Output);

  PROCEDURE Red_Led_On is
  BEGIN

    LED_red.Put(True);

  END Red_Led_On;

  PROCEDURE Red_Led_Off is
  BEGIN

    LED_red.Put(False);

  END Red_Led_Off;

END GPIO_pack;
