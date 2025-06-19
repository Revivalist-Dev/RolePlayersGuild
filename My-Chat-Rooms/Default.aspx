<%@ Page Title="My Chat Rooms on RPG" Language="C#" MasterPageFile="~/templates/2-Col With Authentication.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.MyChatRooms.Default" %>

<%@ MasterType VirtualPath="~/templates/2-Col With Authentication.master" %>
<%@ Register Src="~/templates/controls/UserNav.ascx" TagPrefix="uc1" TagName="UserNav" %>


<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" runat="server">
    <uc1:UserNav runat="server" ID="UserNav" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphRightCol" runat="server">
    <asp:Panel ID="pnlMessage" runat="server" ViewStateMode="Disabled" Visible="false" role="alert">
        <asp:Literal ID="litMessage" runat="server" ViewStateMode="Disabled"></asp:Literal>
    </asp:Panel>
    <div class="ButtonPanel clearfix">
        <ul>
            <li class="col-sm-4 col-xl-3">
                <a href="/My-Writing/" class="btn btn-default">Back To My Writing</a>
            </li>
            <li class="col-sm-4 col-xl-3"></li>
            <li class="col-sm-4 col-xl-3 col-xl-offset-3"><a href="/My-Chat-Rooms/Edit-Chat-Room?Mode=New" class="btn btn-success">
                <span class="glyphicon glyphicon-plus"></span>
                New Chat Room</a></li>
        </ul>
    </div>
    <fieldset class="WritingContent">
        <legend>My Chat Rooms</legend>
        <div class="WritingContentList">
            <asp:Repeater ID="rptChatRooms" runat="server" DataSourceID="sdsChatRooms">
                <ItemTemplate>
                    <div class="WritingContentBoxContainer col-xs-12">
                        <div class="WritingContentBox">
                            <a href="/My-Chat-Rooms/Edit-Chat-Room?Mode=Edit&id=<%# Eval("ChatRoomID") %>" class="WritingContentName"><%# Eval("ChatRoomName") %> &raquo;</a>
                            <div class="WritingContentDetails">
                                <ul class="Info">
                                    <li><span>Universe:</span> <%# Eval("UniverseName") %></li>
                                    <li><span>Rating:</span> <%# Eval("ContentRating") %></li>
                                    <li><span>Last Post:</span> <%# GetTimeAgo(Eval("LastPostTime")) %></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        <asp:SqlDataSource ID="sdsChatRooms" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT * FROM [ChatRoomsForListing] WHERE ([ChatRoomStatusID] = 2) AND (UniverseOwnerID = @UserID or SubmittedByUserID = @UserID) Order By ChatRoomName">
            <SelectParameters>
                <asp:SessionParameter Name="UserID" SessionField="UserID" />
            </SelectParameters>
        </asp:SqlDataSource>
    </fieldset>
</asp:Content>
