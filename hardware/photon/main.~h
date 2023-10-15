//---------------------------------------------------------------------------

#ifndef mainH
#define mainH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ExtCtrls.hpp>
#include <Grids.hpp>
#include <ComCtrls.hpp>
#include <Menus.hpp>
#include <Buttons.hpp>
#include <ToolWin.hpp>
#include <Graphics.hpp>
#include <CheckLst.hpp>
#include <ValEdit.hpp>
#include "CGAUGES.h"
#include <Outline.hpp>
#include <FileCtrl.hpp>
#include <OleCtnrs.hpp>
#include <Dialogs.hpp>
#include <AppEvnts.hpp>
#include "trayicon.h"
#include "CGRID.h"
#include "PERFGRAP.h"
#include <ActnList.hpp>
#include <ActnMan.hpp>
#include <ScktComp.hpp>
#include <MPlayer.hpp>
#include <IdBaseComponent.hpp>
#include <IdComponent.hpp>
#include <IdMappedPortTCP.hpp>
#include <IdTCPServer.hpp>
#include <Sockets.hpp>
#include <IdHTTP.hpp>
#include <IdTCPClient.hpp>
#include <IdTCPConnection.hpp>
#include <IdTelnet.hpp>
#include <IdTelnetServer.hpp>
#include <IdHTTPServer.hpp>
#include "SHDocVw_OCX.h"
#include <OleServer.hpp>
#include <DB.hpp>
#include <DBTables.hpp>
#include <DBCtrls.hpp>
#include <DBGrids.hpp>
#include <IdTrivialFTPServer.hpp>
#include <IdUDPBase.hpp>
#include <IdUDPServer.hpp>
#include <IdIMAP4Server.hpp>
#include <IdSimpleServer.hpp>
//---------------------------------------------------------------------------
class Tfmain : public TForm
{
__published:	// IDE-managed Components
        TOpenDialog *OpenDialog1;
        TSaveDialog *SaveDialog2;
        TPopupMenu *PopupMenu1;
        TMenuItem *Copy1;
        TMenuItem *Paste1;
        TPanel *Panel1;
        TMenuItem *N8;
        TMenuItem *Shift1;
        TMenuItem *N11;
        TMenuItem *N21;
        TMenuItem *N31;
        TMenuItem *N41;
        TMenuItem *N51;
        TMenuItem *N101;
        TMenuItem *N10;
        TMenuItem *Reset1;
        TMenuItem *ShiftLeft1;
        TMenuItem *N12;
        TMenuItem *N22;
        TMenuItem *N32;
        TMenuItem *N42;
        TMenuItem *N52;
        TMenuItem *N102;
        TPanel *Panel5;
        TOpenDialog *OpenDialog2;
        TSaveDialog *SaveDialog1;
  TSpeedButton *SpeedButton1;
  TSpeedButton *SpeedButton2;
  TSpeedButton *SpeedButton3;
  TSpeedButton *SpeedButton4;
  TSpeedButton *SpeedButton5;
  TSpeedButton *SpeedButton6;
  TSpeedButton *SpeedButton7;
  TSpeedButton *SpeedButton8;
  TSpeedButton *SpeedButton9;
  TSpeedButton *SpeedButton10;
  TSpeedButton *SpeedButton11;
  TPanel *Panel10;
  TGroupBox *GroupBox2;
  TSpeedButton *SpeedButton12;
  TSpeedButton *SpeedButton13;
  TComboBox *combo_type;
  TComboBox *combo_cond;
  TComboBox *combo_flags_src;
  TEdit *edt_integer;
  TGroupBox *GroupBox1;
  TComboBox *combo_zbus;
  TGroupBox *GroupBox3;
  TComboBox *combo_of_in;
  TComboBox *combo_sf_in;
  TComboBox *combo_cf_in;
  TComboBox *combo_zf_in;
  TGroupBox *GroupBox4;
  TComboBox *combo_aluAmux;
  TComboBox *combo_aluBmux;
  TGroupBox *GroupBox5;
  TComboBox *combo_mdr_src_out;
  TComboBox *combo_mdr_src;
  TGroupBox *GroupBox6;
  TComboBox *combo_uof;
  TComboBox *combo_usf;
  TComboBox *combo_ucf;
  TComboBox *combo_uzf;
  TGroupBox *GroupBox7;
  TComboBox *combo_aluop;
  TComboBox *combo_alu_cf_in;
  TComboBox *combo_alu_cf_out_inv;
  TGroupBox *GroupBox8;
  TComboBox *combo_mar_src;
  TGroupBox *GroupBox9;
  TComboBox *combo_shift_src;
  TPanel *Panel4;
  TListBox *list_names;
  TPanel *Panel2;
  TPanel *Panel8;
  TListBox *list_cycle;
  TPanel *Panel9;
  TSplitter *Splitter2;
  TCheckListBox *control_list;
  TPanel *Panel3;
  TMemo *memo_info;
  TMemo *memo_name;
  TSplitter *Splitter1;
  TPanel *Panel6;
  TPanel *panelstatus;
  TSpeedButton *SpeedButton17;
  TSpeedButton *SpeedButton16;
  TSpeedButton *SpeedButton15;
  TSpeedButton *SpeedButton14;
  TSpeedButton *SpeedButton20;
  TSpeedButton *SpeedButton21;
  TSpeedButton *SpeedButton18;
  TSpeedButton *SpeedButton19;


        void __fastcall Button34Click(TObject *Sender);
       

      

        void __fastcall control_listClickCheck(TObject *Sender);
        void __fastcall memo_infoKeyDown(TObject *Sender, WORD &Key,
          TShiftState Shift);
        void __fastcall memo_infoKeyUp(TObject *Sender, WORD &Key,
          TShiftState Shift);
        void __fastcall list_cycleClick(TObject *Sender);
        void __fastcall combo_typeSelect(TObject *Sender);
   

        void __fastcall combo_aluAmuxSelect(TObject *Sender);
        void __fastcall combo_aluBmuxSelect(TObject *Sender);
        void __fastcall combo_aluopSelect(TObject *Sender);
        void __fastcall Copy1Click(TObject *Sender);
        void __fastcall Paste1Click(TObject *Sender);
     
 
        void __fastcall combo_condSelect(TObject *Sender);
        void __fastcall combo_alu_cf_inSelect(TObject *Sender);
        void __fastcall combo_mdr_srcSelect(TObject *Sender);
        void __fastcall combo_mar_srcSelect(TObject *Sender);
        void __fastcall combo_zf_inSelect(TObject *Sender);
        void __fastcall combo_cf_inSelect(TObject *Sender);
        void __fastcall combo_sf_inSelect(TObject *Sender);
        void __fastcall combo_of_inSelect(TObject *Sender);
        void __fastcall list_namesClick(TObject *Sender);
        void __fastcall memo_nameChange(TObject *Sender);
        void __fastcall combo_flags_srcSelect(TObject *Sender);
        void __fastcall combo_mdr_src_outSelect(TObject *Sender);
        void __fastcall combo_shift_srcSelect(TObject *Sender);
        void __fastcall combo_zbusSelect(TObject *Sender);
        void __fastcall combo_uzfSelect(TObject *Sender);
        void __fastcall combo_ucfSelect(TObject *Sender);
        void __fastcall combo_usfSelect(TObject *Sender);
        void __fastcall combo_uofSelect(TObject *Sender);
        void __fastcall N11Click(TObject *Sender);
        void __fastcall N21Click(TObject *Sender);
        void __fastcall N31Click(TObject *Sender);
        void __fastcall N41Click(TObject *Sender);
        void __fastcall N51Click(TObject *Sender);
        void __fastcall N101Click(TObject *Sender);
        void __fastcall StringGrid2KeyPress(TObject *Sender, char &Key);
        void __fastcall StringGrid2SelectCell(TObject *Sender, int ACol,
          int ARow, bool &CanSelect);
        void __fastcall list_cycleKeyPress(TObject *Sender, char &Key);
        void __fastcall Reset1Click(TObject *Sender);


       
        void __fastcall memo_text12Enter(TObject *Sender);

        void __fastcall Directory1Click(TObject *Sender);
        
        void __fastcall memo_text112Enter(TObject *Sender);
        void __fastcall FormShow(TObject *Sender);
	void __fastcall Save1Click(TObject *Sender);
	void __fastcall SaveAs1Click(TObject *Sender);
	void __fastcall Open1Click(TObject *Sender);

	void __fastcall New1Click(TObject *Sender);
	void __fastcall Copyinstruction1Click(TObject *Sender);
	void __fastcall PasteInstruction1Click(TObject *Sender);
	void __fastcall combo_alu_cf_out_invSelect(TObject *Sender);
	void __fastcall N110Click(TObject *Sender);
	void __fastcall N28Click(TObject *Sender);
	void __fastcall N33Click(TObject *Sender);
	void __fastcall N43Click(TObject *Sender);
	void __fastcall N53Click(TObject *Sender);
	void __fastcall MicrocodeEditor1Click(TObject *Sender);
	void __fastcall telnetClientConnect(TObject *Sender,
          TCustomWinSocket *Socket);


  void __fastcall SpeedButton1Click(TObject *Sender);
  void __fastcall SpeedButton2Click(TObject *Sender);
  void __fastcall SpeedButton3Click(TObject *Sender);
  void __fastcall SpeedButton4Click(TObject *Sender);
  void __fastcall SpeedButton5Click(TObject *Sender);
  void __fastcall SpeedButton6Click(TObject *Sender);
  void __fastcall SpeedButton7Click(TObject *Sender);
  void __fastcall SpeedButton8Click(TObject *Sender);
  void __fastcall SpeedButton9Click(TObject *Sender);
  void __fastcall SpeedButton11Click(TObject *Sender);
  void __fastcall SpeedButton10Click(TObject *Sender);
  void __fastcall SpeedButton12Click(TObject *Sender);
  void __fastcall SpeedButton13Click(TObject *Sender);
  void __fastcall Exit1Click(TObject *Sender);
  void __fastcall SpeedButton19Click(TObject *Sender);
  void __fastcall SpeedButton18Click(TObject *Sender);
  void __fastcall SpeedButton20Click(TObject *Sender);
  void __fastcall SpeedButton21Click(TObject *Sender);
  void __fastcall SpeedButton14Click(TObject *Sender);
  void __fastcall SpeedButton15Click(TObject *Sender);
  void __fastcall SpeedButton16Click(TObject *Sender);
  void __fastcall SpeedButton17Click(TObject *Sender);

private:	// User declarations
public:		// User declarations
	__fastcall Tfmain(TComponent* Owner);
        void write_cycle(void);

        struct{
                char name[128];
                int start;
        } bookmarks[256];
        int bookmark_tos;
};
//---------------------------------------------------------------------------
extern PACKAGE Tfmain *fmain;
//---------------------------------------------------------------------------
#endif
