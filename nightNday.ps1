Import-Module nightNdayModule.psm1 -Force
Add-Type -TypeDefinition @'
using System.Runtime.InteropServices;
[Guid("D666063F-1587-4E43-81F1-B948E807363F"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IMMDevice {
    int a(); int o();
    int GetId([MarshalAs(UnmanagedType.LPWStr)] out string id);
}
[Guid("A95664D2-9614-4F35-A746-DE8DB63617E6"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IMMDeviceEnumerator {
    int f();
    int GetDefaultAudioEndpoint(int dataFlow, int role, out IMMDevice endpoint);
}
[ComImport, Guid("BCDE0395-E52F-467C-8E3D-C4579291692E")] class MMDeviceEnumeratorComObject { }
public class Audio {
    public static string GetDefault (int direction) {
    var enumerator = new MMDeviceEnumeratorComObject() as IMMDeviceEnumerator;
    IMMDevice dev = null;
    Marshal.ThrowExceptionForHR(enumerator.GetDefaultAudioEndpoint(direction, 1, out dev));
    string id = null;
    Marshal.ThrowExceptionForHR(dev.GetId(out id));
    return id;
    }
}
'@

#set-nightlight -mode Night
#$record = get-record
#$record
#set-NightMode $baseData
#set-DayMode

switch-mode