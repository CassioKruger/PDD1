For i In {PostProcessing.NbViews-1:0:-1}
  If(!StrCmp(View[i].Name, 'boundary'))
    View[i].ShowElement=1;
   EndIf
EndFor
