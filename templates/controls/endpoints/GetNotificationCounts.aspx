<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GetNotificationCounts.aspx.cs" Inherits="RolePlayersGuild.templates.controls.endpoints.GetNotificationCounts" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div id="UnreadThreads">
           <span runat="server" id="spanThreadBadge" class="badge" visible="false"></span>
        </div>
        <div id="UnreadImageComments">
            <span runat="server" id="spanImageCommentBadge" class="badge" visible="false"></span>
        </div>
    </form>
</body>
</html>
