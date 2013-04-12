//------------------------------------------------------------------------------
// <autogenerated>
//     This Oxygene source code was generated by a tool.
//     Runtime Version: 4.0.30319.17929
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </autogenerated>
//------------------------------------------------------------------------------

{$HIDE H7}
{$HIDE W1}
{$HIDE W27}
{$HIDE H11}

namespace RemObjects.SDK.Push;

interface

uses
  System,
  RemObjects.SDK,
  RemObjects.SDK.Types,
  RemObjects.SDK.Server;
  
type
  [RemObjects.SDK.Server.Invoker]
  [System.Reflection.ObfuscationAttribute(Exclude := true)]
  ApplePushProviderService_Invoker = public class(RemObjects.SDK.Server.Invoker)
  public 
    constructor;
    class method Invoke_registerDevice(__Instance: RemObjects.SDK.IROService; __Message: RemObjects.SDK.IMessage; __ServerChannelInfo: RemObjects.SDK.Server.IServerChannelInfo; out __oResponseOptions: RemObjects.SDK.Server.ResponseOptions);
    class method Invoke_unregisterDevice(__Instance: RemObjects.SDK.IROService; __Message: RemObjects.SDK.IMessage; __ServerChannelInfo: RemObjects.SDK.Server.IServerChannelInfo; out __oResponseOptions: RemObjects.SDK.Server.ResponseOptions);
  end;
  
  [RemObjects.SDK.Activator]
  [System.Reflection.ObfuscationAttribute(Exclude := true, ApplyToMembers := false)]
  ApplePushProviderService_Activator = public class(RemObjects.SDK.Server.ServiceActivator)
  public 
    constructor;
    method CreateInstance: RemObjects.SDK.IROService; override;
  end;
  
  [RemObjects.SDK.Server.Invoker]
  [System.Reflection.ObfuscationAttribute(Exclude := true)]
  GooglePushProviderService_Invoker = public class(RemObjects.SDK.Server.Invoker)
  public 
    constructor;
    class method Invoke_registerDevice(__Instance: RemObjects.SDK.IROService; __Message: RemObjects.SDK.IMessage; __ServerChannelInfo: RemObjects.SDK.Server.IServerChannelInfo; out __oResponseOptions: RemObjects.SDK.Server.ResponseOptions);
    class method Invoke_unregisterDevice(__Instance: RemObjects.SDK.IROService; __Message: RemObjects.SDK.IMessage; __ServerChannelInfo: RemObjects.SDK.Server.IServerChannelInfo; out __oResponseOptions: RemObjects.SDK.Server.ResponseOptions);
  end;
  
  [RemObjects.SDK.Activator]
  [System.Reflection.ObfuscationAttribute(Exclude := true, ApplyToMembers := false)]
  GooglePushProviderService_Activator = public class(RemObjects.SDK.Server.ServiceActivator)
  public 
    constructor;
    method CreateInstance: RemObjects.SDK.IROService; override;
  end;
  
implementation

{ ApplePushProviderService_Invoker }

constructor ApplePushProviderService_Invoker;
begin
  inherited constructor();
end;

class method ApplePushProviderService_Invoker.Invoke_registerDevice(__Instance: RemObjects.SDK.IROService; __Message: RemObjects.SDK.IMessage; __ServerChannelInfo: RemObjects.SDK.Server.IServerChannelInfo; out __oResponseOptions: RemObjects.SDK.Server.ResponseOptions);
begin
  var __ObjectDisposer: RemObjects.SDK.ObjectDisposer := new RemObjects.SDK.ObjectDisposer(1);
  try
    var deviceToken: RemObjects.SDK.Types.Binary := (__Message.Read('deviceToken', typeOf(RemObjects.SDK.Types.Binary), RemObjects.SDK.StreamingFormat.Default) as RemObjects.SDK.Types.Binary);
    var additionalInfo: System.String := __Message.ReadUtf8String('additionalInfo');
    __ObjectDisposer.Add(deviceToken);
    (__Instance as IApplePushProviderService).registerDevice(deviceToken, additionalInfo);
    __Message.InitializeResponseMessage(__ServerChannelInfo, 'PushProvider', 'ApplePushProviderService', 'registerDeviceResponse');
    __Message.FinalizeMessage();
    __oResponseOptions := RemObjects.SDK.Server.ResponseOptions.roNoResponse;
  finally
    __ObjectDisposer.Dispose();
  end;
end;

class method ApplePushProviderService_Invoker.Invoke_unregisterDevice(__Instance: RemObjects.SDK.IROService; __Message: RemObjects.SDK.IMessage; __ServerChannelInfo: RemObjects.SDK.Server.IServerChannelInfo; out __oResponseOptions: RemObjects.SDK.Server.ResponseOptions);
begin
  var __ObjectDisposer: RemObjects.SDK.ObjectDisposer := new RemObjects.SDK.ObjectDisposer(1);
  try
    var deviceToken: RemObjects.SDK.Types.Binary := (__Message.Read('deviceToken', typeOf(RemObjects.SDK.Types.Binary), RemObjects.SDK.StreamingFormat.Default) as RemObjects.SDK.Types.Binary);
    __ObjectDisposer.Add(deviceToken);
    (__Instance as IApplePushProviderService).unregisterDevice(deviceToken);
    __Message.InitializeResponseMessage(__ServerChannelInfo, 'PushProvider', 'ApplePushProviderService', 'unregisterDeviceResponse');
    __Message.FinalizeMessage();
    __oResponseOptions := RemObjects.SDK.Server.ResponseOptions.roNoResponse;
  finally
    __ObjectDisposer.Dispose();
  end;
end;

{ ApplePushProviderService_Activator }

constructor ApplePushProviderService_Activator;
begin
  inherited constructor();
end;

method ApplePushProviderService_Activator.CreateInstance: RemObjects.SDK.IROService;
begin
  exit(new ApplePushProviderService());
end;

{ GooglePushProviderService_Invoker }

constructor GooglePushProviderService_Invoker;
begin
  inherited constructor();
end;

class method GooglePushProviderService_Invoker.Invoke_registerDevice(__Instance: RemObjects.SDK.IROService; __Message: RemObjects.SDK.IMessage; __ServerChannelInfo: RemObjects.SDK.Server.IServerChannelInfo; out __oResponseOptions: RemObjects.SDK.Server.ResponseOptions);
begin
  var registrationId: System.String := __Message.ReadAnsiString('registrationId');
  var additionalInfo: System.String := __Message.ReadAnsiString('additionalInfo');
  (__Instance as IGooglePushProviderService).registerDevice(registrationId, additionalInfo);
  __Message.InitializeResponseMessage(__ServerChannelInfo, 'PushProvider', 'GooglePushProviderService', 'registerDeviceResponse');
  __Message.FinalizeMessage();
  __oResponseOptions := RemObjects.SDK.Server.ResponseOptions.roNoResponse;
end;

class method GooglePushProviderService_Invoker.Invoke_unregisterDevice(__Instance: RemObjects.SDK.IROService; __Message: RemObjects.SDK.IMessage; __ServerChannelInfo: RemObjects.SDK.Server.IServerChannelInfo; out __oResponseOptions: RemObjects.SDK.Server.ResponseOptions);
begin
  var registrationId: System.String := __Message.ReadAnsiString('registrationId');
  (__Instance as IGooglePushProviderService).unregisterDevice(registrationId);
  __Message.InitializeResponseMessage(__ServerChannelInfo, 'PushProvider', 'GooglePushProviderService', 'unregisterDeviceResponse');
  __Message.FinalizeMessage();
  __oResponseOptions := RemObjects.SDK.Server.ResponseOptions.roNoResponse;
end;

{ GooglePushProviderService_Activator }

constructor GooglePushProviderService_Activator;
begin
  inherited constructor();
end;

method GooglePushProviderService_Activator.CreateInstance: RemObjects.SDK.IROService;
begin
  exit(new GooglePushProviderService());
end;

end.
