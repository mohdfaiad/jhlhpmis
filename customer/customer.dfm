object bplCustomerFrame: TbplCustomerFrame
  Left = 0
  Top = 0
  Width = 1219
  Height = 603
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -20
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object Splitter1: TSplitter
    Left = 0
    Top = 317
    Width = 1219
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 0
    ExplicitWidth = 416
  end
  object cxGrid1: TcxGrid
    Left = 0
    Top = 0
    Width = 1219
    Height = 317
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 1042
    ExplicitHeight = 416
    object cxGrid1DBTableView1: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = customerDataModule.customerDataSource
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsView.Indicator = True
      Styles.ContentEven = cxStyle1
      Styles.ContentOdd = cxStyle2
    end
    object cxGrid1Level1: TcxGridLevel
      GridView = cxGrid1DBTableView1
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 320
    Width = 1219
    Height = 283
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      1219
      283)
    object expocxLookupComboBox: TcxLookupComboBox
      Left = 100
      Top = 6
      TabStop = False
      Properties.DropDownAutoSize = True
      Properties.DropDownListStyle = lsFixedList
      Properties.DropDownSizeable = True
      Properties.KeyFieldNames = 'id'
      Properties.ListColumns = <
        item
          Caption = #24320#22987#26085#26399
          Width = 100
          FieldName = 'startdate'
        end
        item
          Caption = #23637#20250#21517#31216
          Width = 200
          FieldName = 'title'
        end
        item
          Caption = #23637#20250#22320#28857
          Width = 150
          FieldName = 'addr'
        end>
      Properties.ListFieldIndex = 1
      Properties.ListOptions.SyncMode = True
      Properties.ListSource = customerDataModule.expoDataSource
      Properties.OnChange = expocxLookupComboBoxPropertiesChange
      TabOrder = 0
      Width = 741
    end
    object StaticText1: TStaticText
      Left = 9
      Top = 10
      Width = 89
      Height = 31
      Caption = #36873#25321#23637#20250':'
      TabOrder = 1
    end
    object Button1: TButton
      Left = 968
      Top = 242
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = #22686#21152
      TabOrder = 2
    end
    object Button2: TButton
      Left = 1049
      Top = 242
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = #37325#32622
      TabOrder = 3
    end
    object StaticText2: TStaticText
      Left = 216
      Top = 51
      Width = 69
      Height = 31
      Caption = #23637#20301#21495':'
      TabOrder = 4
    end
    object StaticText3: TStaticText
      Left = 388
      Top = 51
      Width = 49
      Height = 31
      Caption = #22995#21517':'
      TabOrder = 5
    end
    object StaticText4: TStaticText
      Left = 569
      Top = 51
      Width = 49
      Height = 31
      Caption = #25163#26426':'
      TabOrder = 6
    end
    object StaticText5: TStaticText
      Left = 787
      Top = 51
      Width = 49
      Height = 31
      Caption = #20844#21496':'
      TabOrder = 7
    end
    object StaticText6: TStaticText
      Left = 9
      Top = 131
      Width = 49
      Height = 31
      Caption = #30005#35805':'
      TabOrder = 8
    end
    object StaticText7: TStaticText
      Left = 9
      Top = 51
      Width = 49
      Height = 31
      Caption = #31867#22411':'
      TabOrder = 9
    end
    object StaticText8: TStaticText
      Left = 9
      Top = 89
      Width = 69
      Height = 31
      Caption = #24635#37329#39069':'
      TabOrder = 10
    end
    object StaticText9: TStaticText
      Left = 216
      Top = 89
      Width = 49
      Height = 31
      Caption = #35746#37329':'
      TabOrder = 11
    end
    object StaticText10: TStaticText
      Left = 397
      Top = 89
      Width = 89
      Height = 31
      Caption = #29616#22330#20132#27454':'
      TabOrder = 12
    end
    object StaticText11: TStaticText
      Left = 642
      Top = 88
      Width = 89
      Height = 31
      Caption = #25903#20184#31867#22411':'
      TabOrder = 13
    end
    object StaticText12: TStaticText
      Left = 216
      Top = 131
      Width = 41
      Height = 31
      Caption = 'QQ:'
      TabOrder = 14
    end
    object StaticText13: TStaticText
      Left = 397
      Top = 132
      Width = 49
      Height = 31
      Caption = #37038#31665':'
      TabOrder = 15
    end
    object StaticText14: TStaticText
      Left = 887
      Top = 88
      Width = 89
      Height = 31
      Caption = #25307#23637#20154#21592':'
      TabOrder = 16
    end
    object StaticText15: TStaticText
      Left = 9
      Top = 169
      Width = 49
      Height = 31
      Caption = #22320#22336':'
      TabOrder = 17
    end
    object StaticText16: TStaticText
      Left = 9
      Top = 205
      Width = 49
      Height = 31
      Caption = #22791#27880':'
      TabOrder = 18
    end
    object Memo1: TMemo
      Left = 64
      Top = 205
      Width = 818
      Height = 62
      Anchors = [akLeft, akTop, akBottom]
      Lines.Strings = (
        'Memo1')
      TabOrder = 19
    end
    object Edit1: TEdit
      Left = 64
      Top = 164
      Width = 818
      Height = 35
      TabOrder = 20
      Text = 'Edit1'
    end
    object cxLookupComboBox1: TcxLookupComboBox
      Left = 65
      Top = 47
      Properties.ListColumns = <>
      TabOrder = 21
      Width = 145
    end
    object Edit2: TEdit
      Left = 285
      Top = 47
      Width = 98
      Height = 35
      TabOrder = 22
      Text = 'Edit1'
    end
    object Edit3: TEdit
      Left = 438
      Top = 47
      Width = 125
      Height = 35
      TabOrder = 23
      Text = 'Edit1'
    end
    object Edit4: TEdit
      Left = 620
      Top = 47
      Width = 161
      Height = 35
      TabOrder = 24
      Text = 'Edit1'
    end
    object Edit5: TEdit
      Left = 842
      Top = 47
      Width = 284
      Height = 35
      TabOrder = 25
      Text = 'Edit1'
    end
    object Edit6: TEdit
      Left = 452
      Top = 126
      Width = 430
      Height = 35
      TabOrder = 26
      Text = 'Edit1'
    end
    object cxCurrencyEdit1: TcxCurrencyEdit
      Left = 83
      Top = 85
      TabOrder = 27
      Width = 127
    end
    object Edit7: TEdit
      Left = 255
      Top = 125
      Width = 138
      Height = 35
      TabOrder = 28
      Text = 'Edit1'
    end
    object cxCurrencyEdit2: TcxCurrencyEdit
      Left = 266
      Top = 85
      TabOrder = 29
      Width = 127
    end
    object cxCurrencyEdit3: TcxCurrencyEdit
      Left = 486
      Top = 85
      TabOrder = 30
      Width = 150
    end
    object cxLookupComboBox2: TcxLookupComboBox
      Left = 737
      Top = 84
      Properties.ListColumns = <>
      TabOrder = 31
      Width = 145
    end
    object cxLookupComboBox3: TcxLookupComboBox
      Left = 981
      Top = 84
      Properties.ListColumns = <>
      TabOrder = 32
      Width = 145
    end
  end
  object cxEditRepository1: TcxEditRepository
    Left = 632
    Top = 325
    object IDcxEditRepository1Label: TcxEditRepositoryLabel
      Properties.Alignment.Horz = taCenter
    end
  end
  object cxPropertiesStore1: TcxPropertiesStore
    Components = <>
    StorageName = 'customer.ini'
    Left = 720
    Top = 320
  end
  object cxStyleRepository1: TcxStyleRepository
    Left = 864
    Top = 328
    PixelsPerInch = 96
    object cxStyle1: TcxStyle
      AssignedValues = [svColor]
      Color = 14024703
    end
    object cxStyle2: TcxStyle
    end
  end
end
