/*  UI-related functions */
int CONNECT_LIST = 0; 
int DISCONNECT_LIST = 1;
int listState = CONNECT_LIST;

void onKetaiListSelection(KetaiList klist)
{
  String selection = klist.getSelection();
  selectName = selection;
  
  if (listState == CONNECT_LIST)
  {
    if (!selection.equals("CANCEL"))
      bt.connectToDeviceByName(selection);
  }else if (listState == DISCONNECT_LIST)
  {
     bt.disconnectDevice(selection); 
  }
  //dispose of list for now
  klist = null;
}
