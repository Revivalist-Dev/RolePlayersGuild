<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddChatContent.aspx.cs" Inherits="RolePlayersGuild.Chat_Rooms.AddChatContent" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <%--<form id="form1" runat="server">
    <div id="Content">
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" InsertCommand="INSERT INTO Chat_Room_Posts(ChatRoomID, PostContent, CharacterID) VALUES (@ChatRoomID, @PostContent, @CharacterID)" SelectCommand="Select * From Chat_Room_Posts">
            <InsertParameters>
                <asp:FormParameter FormField="ChatRoomID" Name="ChatRoomID" />
                <asp:FormParameter FormField="PostContent" Name="PostContent" />
                <asp:FormParameter FormField="CharacterID" Name="CharacterID" />
            </InsertParameters>
        </asp:SqlDataSource>
    </div>
    </form>--%>
</body>
</html>
