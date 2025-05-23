<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GetChatContent.aspx.cs" Inherits="RolePlayersGuild.Chat_Rooms.GetChatContent" ViewStateMode="Disabled" EnableSessionState="False" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="/js/linkify.min.js"></script>
    <script src="/js/linkify-jquery.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">

        <div id="Content">
            <asp:Repeater ID="rptChatPosts" runat="server">
                <ItemTemplate>
                    <div class="Post">

                        <div class="PostDetails clearfix">
                            <div class="Creator col-xs-2 col-xl-1">
                                <a class="CharacterImage" style="background-image: url(<%# Eval("CharacterThumbnail")%>)" href="/Character?id=<%# Eval("CharacterID") %>"></a>
                            </div>
                            <div class="Content col-xs-10 col-xl-11">
                                <strong class="CharacterName"><span class="TimeStamp"><%# ShowTimeAgo(Eval("TimeStamp").ToString()) %> </span></strong>
                                <span data-linkify><a class="<%# Eval("CharacterNameClass") %>" style="font-weight: bold;" href="/Character?id=<%# Eval("CharacterID") %>"><%# Eval("CharacterDisplayName") %></a>: <%# Eval("PostContent") %></span>
                            </div>
                        </div>
                        <div class="Options"></div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <asp:Panel ID="pnlMessage" runat="server" ViewStateMode="Disabled" Visible="false" role="alert">
                <asp:Literal ID="litMessage" runat="server" ViewStateMode="Disabled"></asp:Literal>
            </asp:Panel>
        </div>
        <asp:SqlDataSource ID="sdsChatPosts" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT Top 75 * FROM Chat_Room_Posts Where UserID Not In (Select UserBlockedBy From User_Blocking Where UserBlocked = @UserID) AND UserID not in (Select UserBlocked From User_Blocking Where UserBlockedBy = @UserID) And (Chat_Room_Posts.ChatRoomID = @ChatRoomID) ORDER BY [PostID] DESC;">
            <SelectParameters>
                <asp:FormParameter FormField="ChatRoomID" Name="ChatRoomID" />
                <asp:FormParameter FormField="UserID" Name="UserID" />
            </SelectParameters>
        </asp:SqlDataSource>
        <div id="ChatDescription">
            <asp:Literal ID="litChatDescription" runat="server"></asp:Literal>
        </div>
        <div id="ChatRoomsActive">
            <ul class="list-group" id="ChatRoomList">
                <asp:Repeater ID="rptChatRooms" runat="server" DataSourceID="sdsActiveChatRooms">
                    <ItemTemplate>
                        <li class="list-group-item"><a href="/Chat-Rooms/Room/?Via=InChatActiveChatList&id=<%# Eval("ChatRoomID") %>"><%# Eval("ChatRoomName") %></a> - [<%# Eval("ContentRating") %>] - Last Post: <%# ShowTimeAgo(Eval("LastPostTime").ToString()) %></li>
                    </ItemTemplate>
                </asp:Repeater>
            </ul>
            <asp:SqlDataSource ID="sdsActiveChatRooms" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT Top (5) * FROM [ActiveChatrooms] Where ChatRoomID <> @ChatRoomID AND ChatroomID not in (Select ChatroomID from Chat_Room_Locks where UserID = @UserID) AND (SubmittedByUserID not in (Select UserBlocked from User_Blocking Where UserBlockedBy = @UserID) And SubmittedByUserID not in (Select UserBlockedBy from User_Blocking Where UserBlocked = @UserID)) ORDER BY [LastPostTime] DESC">
                <SelectParameters>
                    <asp:FormParameter FormField="ChatRoomID" Name="ChatRoomID" />
                    <asp:FormParameter FormField="UserID" Name="UserID" />
                </SelectParameters>
            </asp:SqlDataSource>
        </div>
    </form>
</body>
</html>
