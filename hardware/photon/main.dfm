object fmain: Tfmain
  Left = -8
  Top = -8
  Width = 1894
  Height = 984
  Caption = 'Photon Microcode Compiler ver. 1.0'
  Color = 2829611
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF009999
    999999999999999999999999999994444F00F40F444444444444444444499C44
    4F00F40F444444444444444444499CC44F0F0F0F444444440000004444499CCC
    4F0F0F0F444440008888880044499CCCCF04F00F444008888888888804499CCC
    CF00000F4008F8F8F8F8888804499CCCCF04F00F0F8F88888888800004499CCC
    CF0F0040F8F8F8F8F800078804499CCCCCF0040F8F888F880077787804499CCC
    CCCFC0F8F8F8F8F00787878044499CCCCCCC0F8F8F8F80070878788044499CCC
    CCC0F8F8F8F807770787880444499CCCCCC0FFFF8F8077780878780444499CCC
    CC08F8F8F80F77870787804444499CCCCC0FFF8F80F0F7780878044444499CCC
    C0F8F8F8078F0F870787044444499CCCC0FF8FF07777F0F80880444444499CCC
    C0F8F8F077878F0F0804444444499CCC0FFFFF07777878F00044444444499CCC
    0FF8F000000000000F4F444444499CCC0FFFF07778787880F0F0F44444499CCC
    0FF807878787870CCF00F44444499CCC0FFF0778787870CCF000F44444499CCC
    0FF8078787800CCCCFFF0F4444499CCC0FF07878780CCCCCCCCCFF4444499CCC
    C0F0777700CCCCCCCCCCCC4444499CCCC0F07700CCCCCCCCCCCCCCC444499CCC
    CC0000CCCCCCCCCCCCCCCCCC44499CCCCCCCCCCCCCCCCCCCCCCCCCCCC4499CCC
    CCCCCCCCCCCCCCCCCCCCCCCCCC49999999999999999999999999999999990000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  OldCreateOrder = False
  Scaled = False
  Visible = True
  WindowState = wsMaximized
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 46
    Width = 1878
    Height = 899
    Align = alClient
    BevelOuter = bvNone
    Color = 1184274
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 691
      Top = 0
      Width = 8
      Height = 899
      Cursor = crHSplit
      AutoSnap = False
      Color = 2829611
      ParentColor = False
      ResizeStyle = rsUpdate
    end
    object Panel10: TPanel
      Left = 0
      Top = 0
      Width = 201
      Height = 899
      Align = alLeft
      BevelOuter = bvNone
      Color = 1184274
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -11
      Font.Name = 'Consolas'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
      object GroupBox2: TGroupBox
        Left = 0
        Top = 0
        Width = 201
        Height = 125
        Align = alTop
        Caption = 'Next Micro-Instruction'
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clAqua
        Font.Height = -12
        Font.Name = 'Consolas'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 0
        object SpeedButton12: TSpeedButton
          Left = 59
          Top = 97
          Width = 62
          Height = 24
          Cursor = crHandPoint
          Caption = 'Offset'
          Flat = True
          OnClick = SpeedButton12Click
        end
        object SpeedButton13: TSpeedButton
          Left = 128
          Top = 97
          Width = 64
          Height = 24
          Cursor = crHandPoint
          Caption = 'Imm'
          Flat = True
          OnClick = SpeedButton13Click
        end
        object combo_type: TComboBox
          Left = 8
          Top = 22
          Width = 185
          Height = 22
          Cursor = crHandPoint
          BevelInner = bvNone
          BevelKind = bkSoft
          BevelOuter = bvNone
          Style = csDropDownList
          Color = 2829611
          Ctl3D = False
          DropDownCount = 50
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clLime
          Font.Height = -12
          Font.Name = 'Consolas'
          Font.Style = []
          ItemHeight = 14
          ItemIndex = 0
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 0
          Text = 'Next by Offset'
          OnSelect = combo_typeSelect
          Items.Strings = (
            'Next by Offset'
            'Branch'
            'Next is Fetch'
            'Next by IR')
        end
        object combo_cond: TComboBox
          Left = 8
          Top = 47
          Width = 185
          Height = 22
          Cursor = crHandPoint
          BevelInner = bvNone
          BevelKind = bkSoft
          BevelOuter = bvNone
          Style = csDropDownList
          Color = 2829611
          Ctl3D = False
          DropDownCount = 50
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clLime
          Font.Height = -12
          Font.Name = 'Consolas'
          Font.Style = []
          ItemHeight = 14
          ItemIndex = 0
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 1
          Text = 'zf'
          OnSelect = combo_condSelect
          Items.Strings = (
            'zf'
            'cf / LU'
            'sf'
            'of'
            'L'
            'LE'
            'LEU'
            'DMA_REQ'
            'STATUS_MODE'
            'WAIT'
            'INT_PENDING'
            'EXT_INPUT'
            'STATUS_DIR'
            'DISPLAY_LOAD'
            'unused'
            'unused'
            '~zf'
            '~cf / GEU'
            '~sf'
            '~of'
            'GE'
            'G'
            'GU'
            '~DMA_REQ'
            '~STATUS_MODE'
            '~WAIT'
            '~INT_PENDING'
            '~EXT_INPUT'
            '~STATUS_DIR'
            '~DISPLAY_R_LOAD'
            'unused'
            'unused')
        end
        object combo_flags_src: TComboBox
          Left = 8
          Top = 72
          Width = 185
          Height = 22
          Cursor = crHandPoint
          BevelInner = bvNone
          BevelKind = bkSoft
          BevelOuter = bvNone
          Style = csDropDownList
          Color = 2829611
          Ctl3D = False
          DropDownCount = 50
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clLime
          Font.Height = -12
          Font.Name = 'Consolas'
          Font.Style = []
          ItemHeight = 14
          ItemIndex = 0
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 2
          Text = 'CPU Flags'
          OnSelect = combo_flags_srcSelect
          Items.Strings = (
            'CPU Flags'
            'Microcode Flags')
        end
        object edt_integer: TEdit
          Left = 8
          Top = 98
          Width = 46
          Height = 19
          BorderStyle = bsNone
          Color = 2829611
          Ctl3D = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clLime
          Font.Height = -12
          Font.Name = 'Consolas'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 3
          Text = '1'
        end
      end
      object GroupBox1: TGroupBox
        Left = 0
        Top = 417
        Width = 201
        Height = 48
        Align = alTop
        Caption = 'ALU to ZBus'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clAqua
        Font.Height = -12
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object combo_zbus: TComboBox
          Left = 8
          Top = 18
          Width = 185
          Height = 22
          Cursor = crHandPoint
          BevelInner = bvNone
          BevelKind = bkSoft
          BevelOuter = bvNone
          Style = csDropDownList
          Color = 2829611
          Ctl3D = False
          DropDownCount = 20
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clLime
          Font.Height = -12
          Font.Name = 'Consolas'
          Font.Style = []
          ItemHeight = 14
          ItemIndex = 0
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 0
          Text = 'Normal ALU Result'
          OnSelect = combo_zbusSelect
          Items.Strings = (
            'Normal ALU Result'
            'Shifted Right'
            'Shifted Left'
            'Sign Extend')
        end
      end
      object GroupBox3: TGroupBox
        Left = 0
        Top = 634
        Width = 201
        Height = 121
        Align = alTop
        Caption = 'Arithmetic Flags In'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clAqua
        Font.Height = -12
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        object combo_of_in: TComboBox
          Left = 8
          Top = 90
          Width = 185
          Height = 22
          Cursor = crHandPoint
          BevelInner = bvNone
          BevelKind = bkSoft
          BevelOuter = bvNone
          Style = csDropDownList
          Color = 2829611
          Ctl3D = False
          DropDownCount = 20
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clLime
          Font.Height = -12
          Font.Name = 'Consolas'
          Font.Style = []
          ItemHeight = 14
          ItemIndex = 0
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 0
          Text = 'unchanged'
          OnSelect = combo_of_inSelect
          Items.Strings = (
            'unchanged'
            'ALU_OF'
            'ZBUS_7'
            'ZBUS_3'
            '(U_SF) XOR (ZBUS_7)')
        end
        object combo_sf_in: TComboBox
          Left = 8
          Top = 66
          Width = 185
          Height = 22
          Cursor = crHandPoint
          BevelInner = bvNone
          BevelKind = bkSoft
          BevelOuter = bvNone
          Style = csDropDownList
          Color = 2829611
          Ctl3D = False
          DropDownCount = 20
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clLime
          Font.Height = -12
          Font.Name = 'Consolas'
          Font.Style = []
          ItemHeight = 14
          ItemIndex = 0
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 1
          Text = 'unchanged'
          OnSelect = combo_sf_inSelect
          Items.Strings = (
            'unchanged'
            'ZBUS_7'
            'GND'
            'ZBUS_2')
        end
        object combo_cf_in: TComboBox
          Left = 8
          Top = 42
          Width = 185
          Height = 22
          Cursor = crHandPoint
          BevelInner = bvNone
          BevelKind = bkSoft
          BevelOuter = bvNone
          Style = csDropDownList
          Color = 2829611
          Ctl3D = False
          DropDownCount = 20
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clLime
          Font.Height = -12
          Font.Name = 'Consolas'
          Font.Style = []
          ItemHeight = 14
          ItemIndex = 0
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 2
          Text = 'unchanged'
          OnSelect = combo_cf_inSelect
          Items.Strings = (
            'unchanged'
            'ALU Final CF'
            'ALU_OUTPUT_0'
            'ZBUS_1'
            'ALU_OUTPUT_7')
        end
        object combo_zf_in: TComboBox
          Left = 8
          Top = 18
          Width = 185
          Height = 22
          Cursor = crHandPoint
          BevelInner = bvNone
          BevelKind = bkSoft
          BevelOuter = bvNone
          Style = csDropDownList
          Color = 2829611
          Ctl3D = False
          DropDownCount = 20
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clLime
          Font.Height = -12
          Font.Name = 'Consolas'
          Font.Style = []
          ItemHeight = 14
          ItemIndex = 0
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 3
          Text = 'unchanged'
          OnSelect = combo_zf_inSelect
          Items.Strings = (
            'unchanged'
            'ALU_ZF'
            'ALU_ZF && ZF'
            'ZBUS_0')
        end
      end
      object GroupBox4: TGroupBox
        Left = 0
        Top = 245
        Width = 201
        Height = 72
        Align = alTop
        Caption = 'ALU Inputs A/B'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clAqua
        Font.Height = -12
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        object combo_aluAmux: TComboBox
          Left = 8
          Top = 19
          Width = 185
          Height = 22
          Cursor = crHandPoint
          BevelInner = bvNone
          BevelKind = bkSoft
          BevelOuter = bvNone
          Style = csDropDownList
          Color = 2829611
          Ctl3D = False
          DropDownCount = 50
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clLime
          Font.Height = -12
          Font.Name = 'Consolas'
          Font.Style = []
          ItemHeight = 14
          ItemIndex = 0
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 0
          Text = '0x00: al'
          OnSelect = combo_aluAmuxSelect
          Items.Strings = (
            '0x00: al'
            '0x01: ah'
            '0x02: bl'
            '0x03: bh'
            '0x04: cl'
            '0x05: ch'
            '0x06: dl'
            '0x07: dh'
            '0x08: sp_l'
            '0x09: sp_h'
            '0x0A: bp_l'
            '0x0B: bp_h'
            '0x0C: si_l'
            '0x0D: si_h'
            '0x0E: di_l'
            '0x0F: di_h'
            '0x10: pc_l'
            '0x11: pc_h'
            '0x12: mar_l'
            '0x13: mar_h'
            '0x14: mdr_l'
            '0x15: mdr_h'
            '0x16: tdr_l'
            '0x17: tdr_h'
            '0x18: ksp_l'
            '0x19: ksp_h'
            '0x1A: int_vector'
            '0x1B: int_masks'
            '0x1C: int_status'
            '0x1D:'
            '0x1E:'
            '0x1F: '
            '0x20: arithmetic_flags'
            '0x21: status_flags'
            '0x22: gl'
            '0x23: gh')
        end
        object combo_aluBmux: TComboBox
          Left = 8
          Top = 42
          Width = 185
          Height = 22
          Cursor = crHandPoint
          BevelInner = bvNone
          BevelKind = bkSoft
          BevelOuter = bvNone
          Style = csDropDownList
          Color = 2829611
          Ctl3D = False
          DropDownCount = 50
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clLime
          Font.Height = -12
          Font.Name = 'Consolas'
          Font.Style = []
          ItemHeight = 14
          ItemIndex = 0
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 1
          Text = 'immediate'
          OnSelect = combo_aluBmuxSelect
          Items.Strings = (
            'immediate'
            ''
            ''
            ''
            'mdr_l'
            'mdr_h'
            'tdr_l'
            'tdr_h')
        end
      end
      object GroupBox5: TGroupBox
        Left = 0
        Top = 171
        Width = 201
        Height = 74
        Align = alTop
        Caption = 'MDR In/Out Src'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clAqua
        Font.Height = -12
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        object combo_mdr_src_out: TComboBox
          Left = 8
          Top = 44
          Width = 185
          Height = 22
          Cursor = crHandPoint
          BevelInner = bvNone
          BevelKind = bkSoft
          BevelOuter = bvNone
          Style = csDropDownList
          Color = 2829611
          Ctl3D = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clLime
          Font.Height = -12
          Font.Name = 'Consolas'
          Font.Style = []
          ItemHeight = 14
          ItemIndex = 0
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 0
          Text = 'MDR Low'
          OnSelect = combo_mdr_src_outSelect
          Items.Strings = (
            'MDR Low'
            'MDR High')
        end
        object combo_mdr_src: TComboBox
          Left = 8
          Top = 20
          Width = 185
          Height = 22
          Cursor = crHandPoint
          BevelInner = bvNone
          BevelKind = bkSoft
          BevelOuter = bvNone
          Style = csDropDownList
          Color = 2829611
          Ctl3D = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clLime
          Font.Height = -12
          Font.Name = 'Consolas'
          Font.Style = []
          ItemHeight = 14
          ItemIndex = 0
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 1
          Text = 'ZBus'
          OnSelect = combo_mdr_srcSelect
          Items.Strings = (
            'ZBus'
            'DataBus')
        end
      end
      object GroupBox6: TGroupBox
        Left = 0
        Top = 515
        Width = 201
        Height = 119
        Align = alTop
        Caption = 'Micro Flags In'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clAqua
        Font.Height = -12
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        object combo_uof: TComboBox
          Left = 8
          Top = 89
          Width = 185
          Height = 22
          Cursor = crHandPoint
          BevelInner = bvNone
          BevelKind = bkSoft
          BevelOuter = bvNone
          Style = csDropDownList
          Color = 2829611
          Ctl3D = False
          DropDownCount = 20
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clLime
          Font.Height = -12
          Font.Name = 'Consolas'
          Font.Style = []
          ItemHeight = 14
          ItemIndex = 0
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 0
          Text = 'unchanged'
          OnSelect = combo_uofSelect
          Items.Strings = (
            'unchanged'
            'ALU_OF')
        end
        object combo_usf: TComboBox
          Left = 8
          Top = 65
          Width = 185
          Height = 22
          Cursor = crHandPoint
          BevelInner = bvNone
          BevelKind = bkSoft
          BevelOuter = bvNone
          Style = csDropDownList
          Color = 2829611
          Ctl3D = False
          DropDownCount = 20
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clLime
          Font.Height = -12
          Font.Name = 'Consolas'
          Font.Style = []
          ItemHeight = 14
          ItemIndex = 0
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 1
          Text = 'unchanged'
          OnSelect = combo_usfSelect
          Items.Strings = (
            'unchanged'
            'ZBUS_7')
        end
        object combo_ucf: TComboBox
          Left = 8
          Top = 41
          Width = 185
          Height = 22
          Cursor = crHandPoint
          BevelInner = bvNone
          BevelKind = bkSoft
          BevelOuter = bvNone
          Style = csDropDownList
          Color = 2829611
          Ctl3D = False
          DropDownCount = 20
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clLime
          Font.Height = -12
          Font.Name = 'Consolas'
          Font.Style = []
          ItemHeight = 14
          ItemIndex = 0
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 2
          Text = 'unchanged'
          OnSelect = combo_ucfSelect
          Items.Strings = (
            'unchanged'
            'ALU Final CF'
            'ALU_OUTPUT_0'
            'ALU_OUTPUT_7')
        end
        object combo_uzf: TComboBox
          Left = 8
          Top = 17
          Width = 185
          Height = 22
          Cursor = crHandPoint
          BevelInner = bvNone
          BevelKind = bkSoft
          BevelOuter = bvNone
          Style = csDropDownList
          Color = 2829611
          Ctl3D = False
          DropDownCount = 20
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clLime
          Font.Height = -12
          Font.Name = 'Consolas'
          Font.Style = []
          ItemHeight = 14
          ItemIndex = 0
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 3
          Text = 'unchanged'
          OnSelect = combo_uzfSelect
          Items.Strings = (
            'unchanged'
            'ALU_ZF'
            'ALU_ZF && uZF'
            'gnd')
        end
      end
      object GroupBox7: TGroupBox
        Left = 0
        Top = 317
        Width = 201
        Height = 100
        Align = alTop
        Caption = 'ALU Operation/Carry '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clAqua
        Font.Height = -12
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
        object combo_aluop: TComboBox
          Left = 8
          Top = 20
          Width = 185
          Height = 22
          Cursor = crHandPoint
          BevelInner = bvNone
          BevelKind = bkSoft
          BevelOuter = bvNone
          Style = csDropDownList
          Color = 2829611
          Ctl3D = False
          DropDownCount = 50
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clLime
          Font.Height = -12
          Font.Name = 'Consolas'
          Font.Style = []
          ItemHeight = 14
          ItemIndex = 0
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 0
          Text = 'ALU Operation'
          OnSelect = combo_aluopSelect
          Items.Strings = (
            'ALU Operation'
            ''
            'plus'
            'minus'
            'and'
            'or'
            'xor'
            'A'
            'B'
            'not A'
            'not B'
            'nand'
            'nor'
            'nxor')
        end
        object combo_alu_cf_in: TComboBox
          Left = 8
          Top = 44
          Width = 185
          Height = 22
          Cursor = crHandPoint
          BevelInner = bvNone
          BevelKind = bkSoft
          BevelOuter = bvNone
          Style = csDropDownList
          Color = 2829611
          Ctl3D = False
          DropDownCount = 50
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clLime
          Font.Height = -12
          Font.Name = 'Consolas'
          Font.Style = []
          ItemHeight = 14
          ItemIndex = 0
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 1
          Text = 'vcc'
          OnSelect = combo_alu_cf_inSelect
          Items.Strings = (
            'vcc'
            'cf'
            'u_cf'
            ''
            'gnd'
            '~cf'
            '~u_cf'
            '')
        end
        object combo_alu_cf_out_inv: TComboBox
          Left = 8
          Top = 68
          Width = 185
          Height = 22
          Cursor = crHandPoint
          BevelInner = bvNone
          BevelKind = bkSoft
          BevelOuter = bvNone
          Style = csDropDownList
          Color = 2829611
          Ctl3D = False
          DropDownCount = 50
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clLime
          Font.Height = -12
          Font.Name = 'Consolas'
          Font.Style = []
          ItemHeight = 14
          ItemIndex = 0
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 2
          Text = 'Carry-out not inverted'
          OnSelect = combo_alu_cf_out_invSelect
          Items.Strings = (
            'Carry-out not inverted'
            'Carry-out inverted')
        end
      end
      object GroupBox8: TGroupBox
        Left = 0
        Top = 125
        Width = 201
        Height = 46
        Align = alTop
        Caption = 'MAR In Src'
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clAqua
        Font.Height = -12
        Font.Name = 'Consolas'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 7
        object combo_mar_src: TComboBox
          Left = 8
          Top = 18
          Width = 185
          Height = 22
          Cursor = crHandPoint
          BevelInner = bvNone
          BevelKind = bkSoft
          BevelOuter = bvNone
          Style = csDropDownList
          Color = 2829611
          Ctl3D = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clLime
          Font.Height = -12
          Font.Name = 'Consolas'
          Font.Style = []
          ItemHeight = 14
          ItemIndex = 0
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 0
          Text = 'MAR IN : ZBus'
          OnSelect = combo_mar_srcSelect
          Items.Strings = (
            'MAR IN : ZBus'
            'MAR IN : PC')
        end
      end
      object GroupBox9: TGroupBox
        Left = 0
        Top = 465
        Width = 201
        Height = 50
        Align = alTop
        Caption = 'Shift Src'
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clAqua
        Font.Height = -12
        Font.Name = 'Consolas'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 8
        object combo_shift_src: TComboBox
          Left = 8
          Top = 19
          Width = 185
          Height = 22
          Cursor = crHandPoint
          BevelInner = bvNone
          BevelKind = bkSoft
          BevelOuter = bvNone
          Style = csDropDownList
          Color = 2829611
          Ctl3D = False
          DropDownCount = 20
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clLime
          Font.Height = -12
          Font.Name = 'Consolas'
          Font.Style = []
          ItemHeight = 14
          ItemIndex = 0
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 0
          Text = 'gnd'
          OnSelect = combo_shift_srcSelect
          Items.Strings = (
            'gnd'
            'uCF'
            'CF'
            'ALU Result [0]'
            'ALU Result [7]')
        end
      end
    end
    object Panel4: TPanel
      Left = 699
      Top = 0
      Width = 1179
      Height = 899
      Align = alClient
      BevelOuter = bvNone
      Color = 1184274
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object list_names: TListBox
        Left = 0
        Top = 0
        Width = 1179
        Height = 899
        AutoComplete = False
        Align = alClient
        BevelInner = bvNone
        Color = 1184274
        Columns = 4
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clLime
        Font.Height = -12
        Font.Name = 'Consolas'
        Font.Style = []
        ItemHeight = 14
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 0
        OnClick = list_namesClick
      end
    end
    object Panel2: TPanel
      Left = 209
      Top = 0
      Width = 482
      Height = 899
      Align = alLeft
      BevelOuter = bvNone
      Color = 1184274
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      object Panel8: TPanel
        Left = 449
        Top = 0
        Width = 33
        Height = 899
        Align = alRight
        BevelOuter = bvNone
        Color = 1184274
        TabOrder = 0
        object list_cycle: TListBox
          Left = 0
          Top = 0
          Width = 33
          Height = 899
          Align = alClient
          BevelEdges = []
          BevelInner = bvNone
          BevelKind = bkFlat
          BevelOuter = bvNone
          BiDiMode = bdLeftToRight
          BorderStyle = bsNone
          Color = 2829611
          Columns = 1
          Ctl3D = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clLime
          Font.Height = -11
          Font.Name = 'Consolas'
          Font.Style = []
          ItemHeight = 13
          Items.Strings = (
            ' 00'
            ' 01'
            ' 02'
            ' 03'
            ' 04'
            ' 05'
            ' 06'
            ' 07'
            ' 08'
            ' 09'
            ' 0A'
            ' 0B'
            ' 0C'
            ' 0D'
            ' 0E'
            ' 0F'
            ' 10'
            ' 11'
            ' 12'
            ' 13'
            ' 14'
            ' 15'
            ' 16'
            ' 17'
            ' 18'
            ' 19'
            ' 1A'
            ' 1B'
            ' 1C'
            ' 1D'
            ' 1E'
            ' 1F'
            ' 20'
            ' 21'
            ' 22'
            ' 23'
            ' 24'
            ' 25'
            ' 26'
            ' 27'
            ' 28'
            ' 29'
            ' 2A'
            ' 2B'
            ' 2C'
            ' 2D'
            ' 2E'
            ' 2F'
            ' 30'
            ' 31'
            ' 32'
            ' 33'
            ' 34'
            ' 35'
            ' 36'
            ' 37'
            ' 38'
            ' 39'
            ' 3A'
            ' 3B'
            ' 3C'
            ' 3D'
            ' 3E'
            ' 3F')
          MultiSelect = True
          ParentBiDiMode = False
          ParentCtl3D = False
          ParentFont = False
          PopupMenu = PopupMenu1
          TabOrder = 0
          OnClick = list_cycleClick
          OnKeyPress = list_cycleKeyPress
        end
      end
      object Panel9: TPanel
        Left = 0
        Top = 0
        Width = 449
        Height = 899
        Align = alClient
        BevelOuter = bvNone
        Color = 1184274
        TabOrder = 1
        object Splitter2: TSplitter
          Left = 0
          Top = 575
          Width = 449
          Height = 8
          Cursor = crVSplit
          Align = alBottom
          AutoSnap = False
          Color = 2829611
          ParentColor = False
          ResizeStyle = rsUpdate
        end
        object control_list: TCheckListBox
          Left = 0
          Top = 0
          Width = 449
          Height = 575
          Cursor = crArrow
          OnClickCheck = control_listClickCheck
          Align = alClient
          BevelInner = bvNone
          BevelOuter = bvNone
          Color = 1184274
          Columns = 3
          Ctl3D = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clLime
          Font.Height = -12
          Font.Name = 'Consolas'
          Font.Style = []
          HeaderColor = clHotLight
          HeaderBackgroundColor = clHotLight
          ItemHeight = 14
          Items.Strings = (
            'next_0'
            'next_1'
            'offset_0'
            'offset_1'
            'offset_2'
            'offset_3'
            'offset_4'
            'offset_5'
            'offset_6'
            'cond_inv'
            'cond_flags_src'
            'cond_sel_0'
            'cond_sel_1'
            'cond_sel_2'
            'cond_sel_3'
            'ESCAPE'
            'uzf_in_src_0'
            'uzf_in_src_1'
            'ucf_in_src_0'
            'ucf_in_src_1'
            'usf_in_src'
            'uof_in_src'
            'ir_wrt'
            'status_wrt'
            'shift_src_0'
            'shift_src_1'
            'shift_src_2'
            'zbus_out_src_0'
            'zbus_out_src_1'
            'alu_a_src_0'
            'alu_a_src_1'
            'alu_a_src_2'
            'alu_a_src_3'
            'alu_a_src_4'
            'alu_a_src_5'
            'alu_op_0'
            'alu_op_1'
            'alu_op_2'
            'alu_op_3'
            'alu_mode'
            'alu_cf_in_src_0'
            'alu_cf_in_src_1'
            'alu_cf_in_inv'
            'zf_in_src_0'
            'zf_in_src_1'
            'alu_cf_out_inv'
            'cf_in_src_0'
            'cf_in_src_1'
            'cf_in_src_2'
            'sf_in_src_0'
            'sf_in_src_1'
            'of_in_src_0'
            'of_in_src_1'
            'of_in_src_2'
            'rd'
            'wr'
            'alu_b_src_0'
            'alu_b_src_1'
            'alu_b_src_2'
            'display_reg_load'
            'dl_wrt'
            'dh_wrt'
            'cl_wrt'
            'ch_wrt'
            'bl_wrt'
            'bh_wrt'
            'al_wrt'
            'ah_wrt'
            'mdr_in_src'
            'mdr_out_src'
            'mdr_out_en'
            'mdrl_wrt'
            'mdrh_wrt'
            'tdrl_wrt'
            'tdrh_wrt'
            'dil_wrt'
            'dih_wrt'
            'sil_wrt'
            'sih_wrt'
            'marl_wrt'
            'marh_wrt'
            'bpl_wrt'
            'bph_wrt'
            'pcl_wrt'
            'pch_wrt'
            'spl_wrt'
            'sph_wrt'
            'unused'
            'unused'
            'irq_vector_wrt'
            'irq_masks_wrt'
            'mar_in_src'
            'irq_ack'
            'clear_all_irqs'
            'ptb_wrt'
            'pagetable_we'
            'mdr_to_pagetable_buff_en'
            'force_user_ptb'
            'unused'
            'unused'
            'unused'
            'unused'
            'gl_wrt'
            'gh_wrt'
            'imm_0'
            'imm_1'
            'imm_2'
            'imm_3'
            'imm_4'
            'imm_5'
            'imm_6'
            'imm_7'
            'unused'
            'unused'
            'unused'
            'unused'
            'unused'
            'unused'
            'unused'
            'unused')
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 0
        end
        object Panel3: TPanel
          Left = 0
          Top = 583
          Width = 449
          Height = 316
          Align = alBottom
          BevelOuter = bvNone
          Color = 1184274
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clLime
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          object memo_info: TMemo
            Left = 0
            Top = 25
            Width = 449
            Height = 291
            Align = alClient
            Color = 1184274
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clLime
            Font.Height = -12
            Font.Name = 'Consolas'
            Font.Style = []
            MaxLength = 256
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 0
            WantTabs = True
            OnKeyDown = memo_infoKeyDown
            OnKeyUp = memo_infoKeyUp
          end
          object memo_name: TMemo
            Left = 0
            Top = 0
            Width = 449
            Height = 25
            Align = alTop
            BevelInner = bvNone
            BevelOuter = bvNone
            BorderStyle = bsNone
            Color = 1184274
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clLime
            Font.Height = -16
            Font.Name = 'Consolas'
            Font.Style = [fsBold]
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 1
            WantReturns = False
            OnChange = memo_nameChange
          end
        end
      end
    end
    object Panel6: TPanel
      Left = 201
      Top = 0
      Width = 8
      Height = 899
      Align = alLeft
      BevelOuter = bvNone
      Color = 2829611
      Ctl3D = False
      UseDockManager = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 3
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 0
    Width = 1878
    Height = 46
    Align = alTop
    BevelOuter = bvNone
    Color = 2829611
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 1
    object SpeedButton1: TSpeedButton
      Left = 994
      Top = 4
      Width = 80
      Height = 38
      Cursor = crHandPoint
      Caption = 'Quit'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clAqua
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 904
      Top = 4
      Width = 80
      Height = 38
      Cursor = crHandPoint
      Caption = 'Reset'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clAqua
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButton2Click
    end
    object SpeedButton3: TSpeedButton
      Left = 127
      Top = 4
      Width = 74
      Height = 37
      Cursor = crHandPoint
      Caption = 'Export'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clAqua
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
      OnClick = SpeedButton3Click
    end
    object SpeedButton4: TSpeedButton
      Left = 449
      Top = 22
      Width = 45
      Height = 19
      Cursor = crHandPoint
      Caption = 'I+'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clAqua
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButton4Click
    end
    object SpeedButton5: TSpeedButton
      Left = 493
      Top = 22
      Width = 45
      Height = 19
      Cursor = crHandPoint
      Caption = 'C+'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clAqua
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButton5Click
    end
    object SpeedButton6: TSpeedButton
      Left = 493
      Top = 4
      Width = 45
      Height = 19
      Cursor = crHandPoint
      Caption = 'C-'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clAqua
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButton6Click
    end
    object SpeedButton7: TSpeedButton
      Left = 449
      Top = 4
      Width = 45
      Height = 19
      Cursor = crHandPoint
      Caption = 'I-'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clAqua
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButton7Click
    end
    object SpeedButton8: TSpeedButton
      Left = 596
      Top = 4
      Width = 50
      Height = 38
      Cursor = crHandPoint
      Caption = 'SHR'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clAqua
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButton8Click
    end
    object SpeedButton9: TSpeedButton
      Left = 547
      Top = 4
      Width = 50
      Height = 38
      Cursor = crHandPoint
      Caption = 'SHL'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clAqua
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButton9Click
    end
    object SpeedButton10: TSpeedButton
      Left = 342
      Top = 22
      Width = 99
      Height = 19
      Cursor = crHandPoint
      Caption = 'Paste cycles'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clAqua
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButton10Click
    end
    object SpeedButton11: TSpeedButton
      Left = 342
      Top = 4
      Width = 99
      Height = 19
      Cursor = crHandPoint
      Caption = 'Copy cycles'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clAqua
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButton11Click
    end
    object SpeedButton17: TSpeedButton
      Left = 59
      Top = 22
      Width = 60
      Height = 19
      Cursor = crHandPoint
      Caption = 'Save As'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clAqua
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
      OnClick = SpeedButton17Click
    end
    object SpeedButton16: TSpeedButton
      Left = 0
      Top = 22
      Width = 60
      Height = 19
      Cursor = crHandPoint
      Caption = 'Save'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clAqua
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
      OnClick = SpeedButton16Click
    end
    object SpeedButton15: TSpeedButton
      Left = 59
      Top = 4
      Width = 60
      Height = 19
      Cursor = crHandPoint
      Caption = 'Open'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clAqua
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
      OnClick = SpeedButton15Click
    end
    object SpeedButton14: TSpeedButton
      Left = 0
      Top = 4
      Width = 60
      Height = 19
      Cursor = crHandPoint
      Caption = 'New'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clAqua
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
      OnClick = SpeedButton14Click
    end
    object SpeedButton20: TSpeedButton
      Left = 207
      Top = 4
      Width = 129
      Height = 19
      Cursor = crHandPoint
      Caption = 'Copy Instruction'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clAqua
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButton20Click
    end
    object SpeedButton21: TSpeedButton
      Left = 207
      Top = 22
      Width = 129
      Height = 19
      Cursor = crHandPoint
      Caption = 'Paste Instruction'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clAqua
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButton21Click
    end
    object SpeedButton18: TSpeedButton
      Left = 655
      Top = 4
      Width = 128
      Height = 38
      Cursor = crHandPoint
      Caption = 'Mode: Read-only'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clAqua
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButton18Click
    end
    object SpeedButton19: TSpeedButton
      Left = 782
      Top = 4
      Width = 112
      Height = 38
      Cursor = crHandPoint
      Caption = 'Toggle Editor'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clAqua
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButton19Click
    end
    object panelstatus: TPanel
      Left = 1443
      Top = 0
      Width = 435
      Height = 46
      Align = alRight
      BevelOuter = bvNone
      Color = 2829611
      Ctl3D = False
      UseDockManager = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Microcode Files (*.*)|*.*'
    Left = 728
    Top = 344
  end
  object SaveDialog2: TSaveDialog
    Filter = 'Microcode Files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Save As'
    Left = 760
    Top = 344
  end
  object PopupMenu1: TPopupMenu
    Left = 768
    Top = 288
    object Copy1: TMenuItem
      Caption = 'Copy'
      OnClick = Copy1Click
    end
    object Paste1: TMenuItem
      Caption = 'Paste'
      OnClick = Paste1Click
    end
    object N8: TMenuItem
      Caption = '-'
    end
    object ShiftLeft1: TMenuItem
      Caption = 'Shift Left'
      object N12: TMenuItem
        Caption = '1'
      end
      object N22: TMenuItem
        Caption = '2'
      end
      object N32: TMenuItem
        Caption = '3'
      end
      object N42: TMenuItem
        Caption = '4'
      end
      object N52: TMenuItem
        Caption = '5'
      end
      object N102: TMenuItem
        Caption = '10'
      end
    end
    object Shift1: TMenuItem
      Caption = 'Shift Right'
      object N11: TMenuItem
        Caption = '1'
        OnClick = N11Click
      end
      object N21: TMenuItem
        Caption = '2'
        OnClick = N21Click
      end
      object N31: TMenuItem
        Caption = '3'
        OnClick = N31Click
      end
      object N41: TMenuItem
        Caption = '4'
        OnClick = N41Click
      end
      object N51: TMenuItem
        Caption = '5'
        OnClick = N51Click
      end
      object N101: TMenuItem
        Caption = '10'
        OnClick = N101Click
      end
    end
    object N10: TMenuItem
      Caption = '-'
    end
    object Reset1: TMenuItem
      Caption = 'Reset'
      OnClick = Reset1Click
    end
  end
  object OpenDialog2: TOpenDialog
    Filter = 'All files (*.*)|*.*|Assembly (*.asm)|*.asm|Text (*.txt)|*.txt'
    Left = 696
    Top = 344
  end
  object SaveDialog1: TSaveDialog
    Filter = 'All files (*.*)|*.*|Assembly (*.asm)|*.asm|Text (*.txt)|*.txt'
    Title = 'Save As'
    Left = 792
    Top = 344
  end
end
