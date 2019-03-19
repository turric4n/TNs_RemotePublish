unit TNsRemotePublish.Domain.Interfaces.PublishFunctionality;

interface

uses
  System.Classes;

type
  IPublishFunctionality = interface['{E7733EEE-DC9B-4BBB-AD6C-6A347EAE7297}']
    function Extract : Boolean;
    function Copy : Boolean;
    function Move : Boolean;
    function Rename : Boolean;
    function Takeoffline : Boolean;
  end;

implementation

end.
