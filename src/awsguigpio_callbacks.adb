------------------------------------------------------------------------------
--                              Ada Web Server                              --
--                                                                          --
--                     Copyright (C) 2010-2012, AdaCore                     --
--                                                                          --
--  This is free software;  you can redistribute it  and/or modify it       --
--  under terms of the  GNU General Public License as published  by the     --
--  Free Software  Foundation;  either version 3,  or (at your option) any  --
--  later version.  This software is distributed in the hope  that it will  --
--  be useful, but WITHOUT ANY WARRANTY;  without even the implied warranty --
--  of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU     --
--  General Public License for  more details.                               --
--                                                                          --
--  You should have  received  a copy of the GNU General  Public  License   --
--  distributed  with  this  software;   see  file COPYING3.  If not, go    --
--  to http://www.gnu.org/licenses for a complete copy of the license.      --
------------------------------------------------------------------------------

with AWS.Messages;
with AWS.MIME;
with AWS.Services.Web_Block.Registry;
with AWS.Utils;
with Ada.Strings.Unbounded;
with GPIO_pack;

package body AWSguiGPIO_Callbacks is

   -------------
   -- Counter --
   -------------

   procedure Counter
     (Request      : in              Status.Data;
      Context      : not null access Web_Block.Context.Object;
      Translations : in out          Templates.Translate_Set)
   is
      package SU   renames Ada.Strings.Unbounded;
      N : SU.Unbounded_String := SU.To_Unbounded_String ("OFF");

   begin
      if Context.Exist ("N") then
         N := SU.To_Unbounded_String (Context.Get_Value ("N"));
      end if;

      if Templates.Get (Templates.Get (Translations, "OP")) = "ADD" then
          GPIO_pack.Red_Led_On;
          N := SU.To_Unbounded_String ("ON");
      elsif Templates.Get (Templates.Get (Translations, "OP")) = "SUB"
      then
          GPIO_pack.Red_Led_Off;
          N := SU.To_Unbounded_String ("OFF");
      end if;

      Context.Set_Value ("N", SU.To_String(N));

      Templates.Insert
        (Translations, Templates.Assoc ("COUNTER", N));
   end Counter;

   ----------
   -- Main --
   ----------

   function Main (Request : in Status.Data) return Response.Data is
      URI : constant String := Status.URI (Request);
      Set : Templates.Translate_Set;
   begin
      if URI = "/add" then
         Templates.Insert (Set, Templates.ASSOC ("OP", "ADD"));
      elsif URI = "/sub" then
         Templates.Insert (Set, Templates.ASSOC ("OP", "SUB"));
      end if;

      return Web_Block.Registry.Build
        (Key          => "/",
         Request      => Request,
         Translations => Set);
   end Main;

end AWSguiGPIO_Callbacks;
