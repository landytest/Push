﻿namespace RemObjects.SDK.ApplePushProvider;

interface

uses
  System.Collections.Generic,
  System.Globalization,
  System.IO,
  System.Linq,
  System.Security.Cryptography.X509Certificates,
  System.Text, 
  System.Xml,
  System.Xml.Linq,
  System.Xml.Serialization,
  RemObjects.SDK.Types;

type
  PushDeviceInfo = public class
  public
    property Token: Binary;
    property UserReference: String;
    property ClientInfo: String;
    property ServerInfo: String;
    property LastSeen: DateTime;
  end;

  PushDeviceManager = public static class
  private
    fDevices: Dictionary<String, PushDeviceInfo>;
    fFilename: String;
    fAPSConnect: APSConnect;
    method set_CertificateFile(value: String);
    method set_Filename(value: String);

    method Load;
    method Save;
    constructor;
  assembly
  public
    property Devices: Dictionary<String, PushDeviceInfo> read fDevices;
    property APSConnect: APSConnect read fAPSConnect;

    // Filename for Device Store XML
    property DeviceStoreFile: String read fFilename write set_Filename;
    // Filename for Certificate .p12
    property CertificateFile: String write set_CertificateFile;

    // Toggles whether Users need to Log in before registering devices
    property RequireSession: Boolean;

    method PushMessageNotificationToAllDevices(aMessage: String);
    method PushBadgeNotificationToAllDevices(aBadge: Int32);
    method PushAudioNotificationToAllDevices(aSound: String);
    method PushCombinedNotificationToAllDevices(aMessage: String; aBadge: nullable Int32; aSound: String);

    method StringToBinary(aString: String): Binary;
    method BinaryToString(aBinary: Binary): String;

    method Flush;

    event DeviceRegistered: DeviceEvent assembly raise;
    event DeviceUnregistered: DeviceEvent assembly raise;
  end;

  DeviceEvent = public delegate(sender: Object; ea: DeviceEventArgs);

  DeviceEventArgs = public class(EventArgs)
  public
    property DeviceToken: String;
  end;  

implementation

constructor PushDeviceManager;
begin
  Load;
end;

method PushDeviceManager.set_Filename(value: String);
begin
  if fFilename <> value then begin
    fFilename := value;
    Load();
  end;
end;

method PushDeviceManager.set_CertificateFile(value: String);
begin
  var lData := Mono.Security.X509.PKCS12.LoadFromFile(value, nil);
  var lCertificate := new X509Certificate2(lData.Certificates[0].RawData);
  lCertificate.PrivateKey := System.Security.Cryptography.AsymmetricAlgorithm(lData.Keys[0]);
  fAPSConnect := new APSConnect(lCertificate);
end;

method PushDeviceManager.Flush;
begin
  Save;
end;

method PushDeviceManager.BinaryToString(aBinary: Binary):String;
begin
  var sb := new StringBuilder;
  for i: Int32 := 0 to 31 do begin
    sb.Append(String.Format('{0:x2}',aBinary.ToArray[i]));
    //if i < 31 then sb.Append('-');
  end;
  result := sb.ToString;
end;

method PushDeviceManager.StringToBinary(aString: String):Binary;
begin
  var aArray := new Byte[32];
  for i: Int32 := 0 to 31 do begin
    var s := aString.Substring(i*2, 2);
    aArray[i] := Int32.Parse(s, NumberStyles.HexNumber);
  end;
  result := new Binary(aArray);
end;

method PushDeviceManager.Save;
begin
  var x := new XDocument;
  var lRoot := new XElement('Devices');
  for each k in fDevices.Keys do begin
    
    var lDeviceNode := new XElement('Device');
    var lInfo := fDevices[k]; 

    lDeviceNode.Add(new XAttribute('Token', k));
    lDeviceNode.Add(new XElement('User',lInfo.UserReference));
    lDeviceNode.Add(new XElement('ClientInfo',lInfo.ClientInfo));
    lDeviceNode.Add(new XElement('ServerInfo',lInfo.ServerInfo));
    lDeviceNode.Add(new XElement('Date',lInfo.LastSeen.ToString('yyyy-MM-dd HH:mm:ss')));
    

    lRoot.Add(lDeviceNode);
  end;
  x.Add(lRoot);
  x.Save(DeviceStoreFile);
end;

method PushDeviceManager.Load;
begin
  fDevices := new Dictionary<String,PushDeviceInfo>;

  if assigned(DeviceStoreFile) and File.Exists(DeviceStoreFile) then begin

    var x := XDocument.Load(DeviceStoreFile);
    for each matching lDeviceNode: XElement in x.Root.Elements do begin
      var lToken := lDeviceNode.Attribute('Token').Value;

      var lDate := DateTime.Now;
      DateTime.TryParse(lDeviceNode.Element('Date'):Value, CultureInfo.InvariantCulture, DateTimeStyles.None, out lDate);

      var p := new PushDeviceInfo(Token := StringToBinary(lToken), 
                                  UserReference := lDeviceNode.Element('User').Value,
                                  ClientInfo := lDeviceNode.Element('ClientInfo').Value,
                                  ServerInfo := lDeviceNode.Element('ServerInfo').Value,
                                  LastSeen := lDate
                                  );
      fDevices.Add(lToken, p);
      //if assigned(fAPSConnect) then fAPSConnect.PushMessageNotification(lToken.ToArray, 'Welcome back. Server has been Started.');
    end;
  end;
end;


method PushDeviceManager.PushMessageNotificationToAllDevices(aMessage: String);
begin
  for each d in fDevices.Values do 
    fAPSConnect.PushMessageNotification(d.Token.ToArray, aMessage);
end;

method PushDeviceManager.PushBadgeNotificationToAllDevices(aBadge: Int32);
begin
  for each d in fDevices.Values do 
    fAPSConnect.PushBadgeNotification(d.Token.ToArray, aBadge);
end;

method PushDeviceManager.PushAudioNotificationToAllDevices(aSound: String);
begin
  for each d in fDevices.Values do 
    fAPSConnect.PushAudioNotification(d.Token.ToArray, aSound);
end;

method PushDeviceManager.PushCombinedNotificationToAllDevices(aMessage: String; aBadge: nullable Int32; aSound: String);
begin
  for each d in fDevices.Values do 
    fAPSConnect.PushCombinedNotification(d.Token.ToArray, aMessage, aBadge, aSound);
end;

end.
