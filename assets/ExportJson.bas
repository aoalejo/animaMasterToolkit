Attribute VB_Name = "ExportJson"
Public Sub exportJson()
    Dim rng As Range, json As String
    Dim intInFile As Integer
    
    json = "{"
    ' Set Attributes Block
    json = json & RangeToJson("Principal", "D11:H18", "A1", "D1", "Atributos")
    
    ' Set Skills Block
    json = json & "," & RangeToJson("Principal", "M22:Q77", "A1", "E1", "Habilidades")
    
    ' Set BasicData Block
    json = json & "," & getBasicData()
    
    ' Set Resistances Block
    json = json & "," & RangeToJson("Principal", "D57:J62", "A1", "G1", "Resistencias")
    
     ' Set Creature Powers Block
    json = json & "," & RangeToJson("Principal", "AB12:AH23", "A1", "E1", "PoderesDeCriatura")
    
    ' Set Elemental Habilities Block
    json = json & "," & RangeToJson("Principal", "AD12:AH69", "A1", "D1", "HabilidadesElementales")
    
    
    ' START Combat Section
    json = json & Replace(", 'Combate': {", "'", Chr(34))
    
    ' Set Weapons Tables Block
    json = json & RangeToJson("Combate", "AH11:AL16", "A1", "E1", "TablasDeArmas")
    
    ' Set Combat Styles Block
    json = json & "," & RangeToJson("Combate", "AB19:AQ28", "A1", "G1", "EstilosDeCombate")
    
    ' Set ArsMagnus Block
    json = json & "," & RangeToJson("Combate", "AB55:AQ64", "A1", "G1", "ArsMagnus")
    
    ' Set Combat Styles Block
    json = json & "," & RangeToJson("Combate", "AB31:AQ49", "A1", "E1", "ArtesMarciales")
    
    ' Set Combat Block
    json = json & ", " & getAllCombatData()
    
    ' END Combat Section
    
    json = json & "}"
    
    ' Set Ki Block
    json = json & Replace(", 'Ki': {", "'", Chr(34))
    
    json = json & RangeToJson("Ki", "C12:D23", "A1", "B1", "Acumulaciones")
    
    json = json & ", " & RangeToJson("Ki", "C35:F36", "A1", "D1", "Habilidades")
    
    json = json & ", " & RangeToJson("Ki", "C12:F23", "A1", "F1", "Maximos")
     
    json = json & ", " & basicKiData()
    
    json = json & "}"
    
    ' Set Elan Block
    
    json = json & ", " & RangeToJson("Elan", "C29:G49", "D1", "E1", "Elan")
    
    ' START Mistic Section
    
    If hasPointsOnMistic() Then
    
        json = json & Replace(", 'Misticos': {", "'", Chr(34))
        
        json = json & getMisticBasicData()
        
        json = json & ", " & RangeToJson("MÌsticos", "C15:H25", "A1", "F1", "Vias")
        
        json = json & ", " & RangeToJson("MÌsticos", "C15:H25", "A1", "C1", "SubVias")
        
        json = json & ", " & RangeToJson("MÌsticos", "W53:AB73", "A1", "F1", "Metamagia")
        
        json = json & ", " & RangeToJson("MÌsticos", "Y12:AC50", "E1", "A1", "Conjuros")
        
        json = json & ", " & RangeToJson("MÌsticos", "AG12:AK50", "E1", "A1", "Libres")
                
        json = json & "}"
    
    End If
    
    ' END Mistic Section
    
    ' START PSY Section
    
    If hasPointsOnPsichiq() Then
    
        json = json & Replace(", 'Psiquicos': {", "'", Chr(34))
        
        json = json & RangeToJson("PsÌquicos", "C25:Q36", "A1", "D1", "Disciplinas")
        
        json = json & ", " & RangeToJson("PsÌquicos", "C39:Q50", "A1", "D1", "Patrones")
        
        json = json & ", " & RangeToJson("PsÌquicos", "V11:AB64", "A1", "G1", "Poderes")
        
        json = json & ", " & RangeToJson("PsÌquicos", "AD17:AK62", "A1", "H1", "Innatos")
        
        
        json = json & "}"
        
    End If
    
    ' END PSY Section
    
    json = json & "}"
    
    Set wbA = ActiveWorkbook
    
    'get active workbook folder, if saved
    strPath = wbA.Path
    If strPath = "" Then
        strPath = Application.DefaultFilePath
    End If
    strPath = strPath & "\"
       
    'replace spaces and periods in character name
    strName = Replace(Range("ResumenNombre").Value, ".", "_")
    
    'create default name for savng file
    strFile = strName & ".json"
    strPathFile = strPath & strFile
    
    'use can enter name and
    ' select folder for file
    myFile = Application.GetSaveAsFilename _
        (InitialFileName:=strPathFile, _
        FileFilter:="Archivos Json (*.json), *.json", _
        Title:="Seleccione directorio y fichero donde guardar")
    
    intInFile = FreeFile
    
    Open myFile For Output As intInFile
        Print #intInFile, json
    Close intInFile
    
    
    Debug.Print json
End Sub

Function basicKiData() As String
    maxAcu = "F24"
    genericAcu = "D24"
  
    items = "'acumulacionMax': '" & Worksheets("Ki").Range(maxAcu) & "',"
    items = items & "'acumulacionGenerica': '" & Worksheets("Ki").Range(genericAcu) & "'"
    
    basicKiData = Replace(items, "'", Chr(34))
End Function

Function hasPointsOnMistic() As Boolean
    If Worksheets("PDs").Range("M101").Value > 0 Then
        hasPointsOnMistic = True
    Else
        hasPointsOnMistic = False
    End If
End Function

Function hasPointsOnPsichiq() As Boolean
    If Worksheets("PDs").Range("M117").Value > 0 Then
        hasPointsOnPsichiq = True
    Else
        hasPointsOnPsichiq = False
    End If
End Function

Function getMisticBasicData() As String
    regen = "J12"
    act = "L12"
    zeon = "K18"
  
    items = "'regen': '" & Worksheets("MÌsticos").Range(regen) & "',"
    items = items & "'act': '" & Worksheets("MÌsticos").Range(act) & "',"
    items = items & "'zeon': '" & Worksheets("MÌsticos").Range(zeon) & "'"
    
    getMisticBasicData = Replace(items, "'", Chr(34))
    
End Function

Function getBasicData() As String
    cansancio = "N16"
    puntosDeVida = "N11"
    regeneracion = "J11"
    movimiento = "J16"
    
    nombre = "K4"
    categoria = "K5"
    nivel = "O6"
    clase = "K7"
    
    acumDanio = "Y13"
    creadoConMagia = "Y14"
    gnosis = "AB13"
    natura = "AB14"
    
    items = "'datosElementales': {"
    
    items = items & "'cansancio': '" & Worksheets("Principal").Range(cansancio) & "',"
    items = items & "'puntosDeVida': '" & Worksheets("Principal").Range(puntosDeVida) & "',"
    items = items & "'regeneracion': '" & Worksheets("Principal").Range(regeneracion) & "',"
    items = items & "'nombre': '" & Worksheets("Principal").Range(nombre) & "',"
    items = items & "'categoria': '" & Worksheets("Principal").Range(categoria) & "',"
    items = items & "'nivel': '" & Worksheets("Principal").Range(nivel) & "',"
    items = items & "'clase': '" & Worksheets("Principal").Range(clase) & "',"
    
    items = items & "'acumDanio': '" & Worksheets("Principal").Range(acumDanio) & "',"
    items = items & "'creadoConMagia': '" & Worksheets("Principal").Range(creadoConMagia) & "',"
    items = items & "'gnosis': '" & Worksheets("Principal").Range(gnosis) & "',"
    items = items & "'natura': '" & Worksheets("Principal").Range(natura) & "',"
    
    items = items & "'movimiento': '" & Worksheets("Principal").Range(movimiento) & "' }"
    
    getBasicData = Replace(items, "'", Chr(34))
End Function

Function getAllCombatData() As String
    Dim items As String, blocksWeaponsBase(5) As String, blocksWeaponsRanged(3) As String
    
    blocksWeaponsBase(0) = "C27:L32"
    blocksWeaponsBase(1) = "C34:L39"
    blocksWeaponsBase(2) = "C41:L46"
    blocksWeaponsBase(3) = "N27:W32"
    blocksWeaponsBase(4) = "N34:W39"
    blocksWeaponsBase(5) = "N41:W46"
    
    blocksWeaponsRanged(0) = "C49:L55"
    blocksWeaponsRanged(1) = "C58:L64"
    blocksWeaponsRanged(2) = "N49:W55"
    blocksWeaponsRanged(3) = "N58:W64"
    
    items = "'armas': ["
        
    items = items & getUnarmedCombatData()
     
    If hasPointsOnMistic() Then
        items = items & getMagicProjectionAsWeapon()
    End If
    
    If hasPointsOnPsichiq() Then
        items = items & getPsychicProjectionAsWeapon()
    End If
        
    For Each block In blocksWeaponsBase
        items = items & getBaseCombatData(Worksheets("Combate").Range(block))
    Next
        
    For Each block In blocksWeaponsRanged
        items = items & getRangedCombatData(Worksheets("Combate").Range(block))
    Next
    
    items = items & "]"
    
    items = items & getArmourData()
    
    getAllCombatData = Replace(items, "'", Chr(34))
End Function

Function getArmourData() As String
    Dim items As String
    Set combatSheet = Worksheets("Combate")
    
    items = ", 'armadura': {"
    items = items & "'restriccionMov': '" & combatSheet.Range("E16").Value & "',"
    items = items & "'penNatural': '" & combatSheet.Range("H17").Value & "',"
    items = items & "'requisito': '" & combatSheet.Range("H16").Value & "',"
    items = items & "'penAccionFisica': '" & combatSheet.Range("S16").Value & "',"
    items = items & "'penNaturalFinal': '" & combatSheet.Range("S17").Value & "'"
                
    items = items & ", 'armaduraTotal': {"
    items = items & "'FIL': '" & combatSheet.Range("I16").Value & "',"
    items = items & "'CON': '" & combatSheet.Range("J16").Value & "',"
    items = items & "'PEN': '" & combatSheet.Range("K16").Value & "',"
    items = items & "'CAL': '" & combatSheet.Range("L16").Value & "',"
    items = items & "'ELE': '" & combatSheet.Range("M16").Value & "',"
    items = items & "'FRI': '" & combatSheet.Range("N16").Value & "',"
    items = items & "'ENE': '" & combatSheet.Range("O16").Value & "'}"
    
    items = items & getArmours() & "}"
    
    getArmourData = Replace(items, "'", Chr(34))

End Function

Function getArmours() As String
    Dim items As String, firstComma As String
    Dim row As Range
    
    Set rng = Worksheets("Combate").Range("C12:S15")
    
    items = ", 'armaduras': ["
          
    For Each row In rng.Rows
        
        If Not row.Range("A1").Value = "" Then
        
            items = items & firstComma & "{ 'nombre': '" & row.Range("A1").Value & "',"
            items = items & "'Localizacion': '" & row.Range("D1").Value & "',"
            items = items & "'calidad': '" & row.Range("F1").Value & "',"
            
            items = items & "'FIL': '" & row.Range("G1").Value & "',"
            items = items & "'CON': '" & row.Range("H1").Value & "',"
            items = items & "'PEN': '" & row.Range("I1").Value & "',"
            items = items & "'CAL': '" & row.Range("J1").Value & "',"
            items = items & "'ELE': '" & row.Range("K1").Value & "',"
            items = items & "'FRI': '" & row.Range("L1").Value & "',"
            items = items & "'ENE': '" & row.Range("M1").Value & "',"
            
            items = items & "'Entereza': '" & row.Range("N1").Value & "',"
            items = items & "'Presencia': '" & row.Range("O1").Value & "',"
            items = items & "'RestMov': '" & row.Range("P1").Value & "',"
            items = items & "'Enc': '" & row.Range("Q1").Value & "'}"
            
            firstComma = ", "
        
        End If
    Next

    items = items & "]"
    
    getArmours = Replace(items, "'", Chr(34))
End Function

Function getMagicProjectionAsWeapon() As String
    Dim items As String, unarmedBlock As Range
    
    Set weaponBlock = Worksheets("MÌsticos").Range("O12:Q13")
    
    turno = "A1"
    ataque = "B1"
    defensa = "C1"
         
    items = ",{"
    items = items & "'nombre': 'ProyecciÛn Magica',"
    items = items & "'tipo': 'MÌstico',"
    items = items & "'conocimiento': 'Conocida',"
    items = items & "'tamanio': 'Normal',"
    items = items & "'critPrincipal': 'Ene',"
    items = items & "'critSecundario': 'Pen',"
    items = items & "'entereza': '999',"
    items = items & "'rotura': '0',"
    items = items & "'presencia': '0',"
    items = items & "'turno': '" & weaponBlock.Range(turno) & "',"
    items = items & "'ataque': '" & weaponBlock.Range(ataque) & "',"
    items = items & "'defensa': '" & weaponBlock.Range(defensa) & "',"
    items = items & "'defensaTipo': 'Par',"
    items = items & "'danio': '100',"
    items = items & "'calidad': '-',"
    items = items & "'caracteristica': '-',"
    items = items & "'advertencia': '-',"
    items = items & "'municion': '-',"
    items = items & "'especial': '-'}"
    
    getMagicProjectionAsWeapon = Replace(items, "'", Chr(34))

End Function

Function getPsychicProjectionAsWeapon() As String
    Dim items As String, unarmedBlock As Range
    
    Set weaponBlock = Worksheets("PsÌquicos").Range("O12:Q13")
    
    turno = "A1"
    ataque = "B1"
    defensa = "C1"
         
    items = ",{"
    items = items & "'nombre': 'ProyecciÛn Psiquica',"
    items = items & "'tipo': 'Psiquica',"
    items = items & "'conocimiento': 'Conocida',"
    items = items & "'tamanio': 'Normal',"
    items = items & "'critPrincipal': 'Ene',"
    items = items & "'critSecundario': 'Pen',"
    items = items & "'entereza': '999',"
    items = items & "'rotura': '0',"
    items = items & "'presencia': '0',"
    items = items & "'turno': '" & weaponBlock.Range(turno) & "',"
    items = items & "'ataque': '" & weaponBlock.Range(ataque) & "',"
    items = items & "'defensa': '" & weaponBlock.Range(defensa) & "',"
    items = items & "'defensaTipo': 'Par',"
    items = items & "'danio': '100',"
    items = items & "'calidad': '-',"
    items = items & "'caracteristica': '-',"
    items = items & "'advertencia': '-',"
    items = items & "'municion': '-',"
    items = items & "'especial': '-'}"
    
    getPsychicProjectionAsWeapon = Replace(items, "'", Chr(34))

End Function

Function getUnarmedCombatData() As String
    Dim items As String, unarmedBlock As Range
    
    Set unarmedBlock = Worksheets("Combate").Range("C20:L25")

    nombre = "A1"
    
    conocimiento = "A2"
    
    critPrincipal = "A4"
    critSecundario = "B4"
    entereza = "C4"
    rotura = "D4"
    presencia = "E4"
    
    turno = "F2"
    ataque = "G2"
    defensa = "H2"
    defensaTipo = "I2"
    danio = "J2"
             
    items = "{"
    items = items & "'nombre': '" & unarmedBlock.Range(nombre) & "',"
    items = items & "'tipo': 'desarmado',"
    items = items & "'conocimiento': '" & unarmedBlock.Range(conocimiento) & "',"
    items = items & "'tamanio': 'Normal',"
    items = items & "'critPrincipal': '" & unarmedBlock.Range(critPrincipal) & "',"
    items = items & "'critSecundario': '" & unarmedBlock.Range(critSecundario) & "',"
    items = items & "'entereza': '" & unarmedBlock.Range(entereza) & "',"
    items = items & "'rotura': '" & unarmedBlock.Range(rotura) & "',"
    items = items & "'presencia': '" & unarmedBlock.Range(presencia) & "',"
    items = items & "'turno': '" & unarmedBlock.Range(turno) & "',"
    items = items & "'ataque': '" & unarmedBlock.Range(ataque) & "',"
    items = items & "'defensa': '" & unarmedBlock.Range(defensa) & "',"
    items = items & "'defensaTipo': '" & unarmedBlock.Range(defensaTipo) & "',"
    items = items & "'danio': '" & unarmedBlock.Range(danio) & "',"
    items = items & "'calidad': '-',"
    items = items & "'caracteristica': '-',"
    items = items & "'advertencia': '-',"
    items = items & "'municion': '-',"
    items = items & "'especial': '-'}"
        
    getUnarmedCombatData = Replace(items, "'", Chr(34))

End Function

Function getBaseCombatData(rangeBlock As Range) As String
    tipo = "A2"
    nombre = "B1"
    
    conocimiento = "A3"
    tamanio = "D3"
    
    critPrincipal = "A5"
    critSecundario = "B5"
    entereza = "C5"
    rotura = "D5"
    presencia = "E5"
    
    turno = "F3"
    ataque = "G3"
    defensa = "H3"
    defensaTipo = "I3"
    danio = "J3"
    
    calidad = "H5"
    especial = "H6"
    caracteristica = "A6"
    advertencia = "I6"
     
    If Not rangeBlock.Range(nombre) = "" Then
    
        items = ", {"
        items = items & "'nombre': '" & rangeBlock.Range(nombre) & "',"
        items = items & "'tipo': '" & rangeBlock.Range(tipo) & "',"
        items = items & "'conocimiento': '" & rangeBlock.Range(conocimiento) & "',"
        items = items & "'tamanio': '" & rangeBlock.Range(tamanio) & "',"
        items = items & "'critPrincipal': '" & rangeBlock.Range(critPrincipal) & "',"
        items = items & "'critSecundario': '" & rangeBlock.Range(critSecundario) & "',"
        items = items & "'entereza': '" & rangeBlock.Range(entereza) & "',"
        items = items & "'rotura': '" & rangeBlock.Range(rotura) & "',"
        items = items & "'presencia': '" & rangeBlock.Range(presencia) & "',"
        items = items & "'turno': '" & rangeBlock.Range(turno) & "',"
        items = items & "'ataque': '" & rangeBlock.Range(ataque) & "',"
        items = items & "'defensa': '" & rangeBlock.Range(defensa) & "',"
        items = items & "'defensaTipo': '" & rangeBlock.Range(defensaTipo) & "',"
        items = items & "'danio': '" & rangeBlock.Range(danio) & "',"
        items = items & "'calidad': '" & rangeBlock.Range(calidad) & "',"
        items = items & "'caracteristica': '" & rangeBlock.Range(caracteristica) & "',"
        items = items & "'advertencia': '" & rangeBlock.Range(advertencia) & "',"
        items = items & "'municion': '-',"
        items = items & "'especial': '" & rangeBlock.Range(especial) & "'}"
        
    End If
    
    getBaseCombatData = Replace(items, "'", Chr(34))
End Function


Function getRangedCombatData(rangeBlock As Range) As String
    tipo = "A1"
    nombre = "C1"
    municion = "C2"
    
    conocimiento = "A3"
    tamanio = "D3"
    
    critPrincipal = "A5"
    critSecundario = "B5"
    entereza = "C5"
    rotura = "D5"
    presencia = "E5"
    
    turno = "F2"
    ataque = "G2"
    defensa = "H2"
    defensaTipo = "I2"
    danio = "J2"
    
    calidad = "H5"
    especial = "H6"
    caracteristica = "A6"
    advertencia = "I6"
     
    If Not rangeBlock.Range(nombre) = "" Then
     
        items = ", {"
        items = items & "'nombre': '" & rangeBlock.Range(nombre) & "',"
        items = items & "'tipo': '" & rangeBlock.Range(tipo) & "',"
        items = items & "'conocimiento': '" & rangeBlock.Range(conocimiento) & "',"
        items = items & "'tamanio': '" & rangeBlock.Range(tamanio) & "',"
        items = items & "'critPrincipal': '" & rangeBlock.Range(critPrincipal) & "',"
        items = items & "'critSecundario': '" & rangeBlock.Range(critSecundario) & "',"
        items = items & "'entereza': '" & rangeBlock.Range(entereza) & "',"
        items = items & "'rotura': '" & rangeBlock.Range(rotura) & "',"
        items = items & "'presencia': '" & rangeBlock.Range(presencia) & "',"
        items = items & "'turno': '" & rangeBlock.Range(turno) & "',"
        items = items & "'ataque': '" & rangeBlock.Range(ataque) & "',"
        items = items & "'defensa': '" & rangeBlock.Range(defensa) & "',"
        items = items & "'defensaTipo': '" & rangeBlock.Range(defensaTipo) & "',"
        items = items & "'danio': '" & rangeBlock.Range(danio) & "',"
        items = items & "'calidad': '" & rangeBlock.Range(calidad) & "',"
        items = items & "'caracteristica': '" & rangeBlock.Range(caracteristica) & "',"
        items = items & "'advertencia': '" & rangeBlock.Range(advertencia) & "',"
        items = items & "'municion': '" & rangeBlock.Range(municion) & "',"
        items = items & "'especial': '" & rangeBlock.Range(especial) & "'}"
        
    End If
        
    getRangedCombatData = Replace(items, "'", Chr(34))
End Function

Function RangeToJson(hoja As String, rangeStr As String, keys As String, values As String, name As String) As String
    Dim items As String, rng As Range, firstComma As String
    Dim row As Range, keysValues As New collection, key As String
    
    Set rng = Worksheets(hoja).Range(rangeStr)
    
    items = "'" & name & "': {"
          
    For Each row In rng.Rows
        key = row.Range(keys)
        
        If Not Contains(keysValues, key) Then
            If Not key = "" Then
                items = items & firstComma & "'" & stripAccent(key) & "': '" & stripAccent(row.Range(values)) & "'"
                keysValues.Add key
                firstComma = ", "
            End If
        End If
    Next

    items = items & "}"
    
    RangeToJson = Replace(items, "'", Chr(34))
End Function

Function stripAccent(Text As String) As String

    Const AccChars = "äéöûü¿¡¬√ƒ≈«»… ÀÃÕŒœ–—“”‘’÷Ÿ⁄€‹›‡·‚„‰ÂÁËÈÍÎÏÌÓÔÒÚÛÙıˆ˘˙˚¸˝ˇ"
    Const RegChars = "SZszYAAAAAACEEEEIIIIDNOOOOOUUUUYaaaaaaceeeeiiiidnooooouuuuyy"

    Dim A As String * 1
    Dim B As String * 1
    Dim i As Integer

    For i = 1 To Len(AccChars)
        A = Mid(AccChars, i, 1)
        B = Mid(RegChars, i, 1)
        Text = Replace(Text, A, B)
    Next

    stripAccent = Text

End Function

Public Function Contains(col As collection, thisItem As Variant) As Boolean

  Dim item As Variant

  Contains = False
  For Each item In col
    If item = thisItem Then
      Contains = True
      Exit Function
    End If
  Next
End Function
