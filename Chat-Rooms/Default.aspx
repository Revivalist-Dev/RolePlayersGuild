<%@ Page Title="Chat Rooms on RPG" Language="C#" MasterPageFile="~/templates/2-Col With Authentication.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.ChatRoom.Default" %>

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
                <a href="/Public-Areas/" class="btn btn-default">Back To Public Areas</a>
            </li>
            <li class="col-sm-4 col-xl-3"></li>
            <li class="col-sm-4 col-xl-3 col-xl-offset-3"><a href="/My-Chat-Rooms/Edit-Chat-Room?Mode=New" class="btn btn-success">
                <span class="glyphicon glyphicon-plus"></span>
                New Chat Room</a></li>
        </ul>
    </div>
    <fieldset class="WritingContent">
        <legend>Chat Rooms</legend>
        <div class="alert alert-info">Below is a list of all Chat Room found within the RPG. You can use this screen to look for a Chat Room you're interested in or create one.</div>
        <div class="WritingContentList">
            <asp:Repeater ID="rptChatRooms" runat="server">
                <ItemTemplate>
                    <div class="WritingContentBoxContainer col-xs-12">
                        <div class="WritingContentBox">
                            <a href="/Chat-Rooms/Room/?id=<%# Eval("ChatRoomID") %>" class="WritingContentName"><%# Eval("ChatRoomName") %> &raquo;</a>
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
             <nav class="PagingControls">
                <ul class="pagination">
                    <%--                    <li>
                        <asp:LinkButton ID="lbFirst" runat="server"
                            OnClick="lbFirst_Click">Newest</asp:LinkButton>
                    </li>--%>
                    <li class="previous">
                        <asp:LinkButton ID="lbFirst" runat="server"
                            OnClick="lbFirst_Click" aria-label="First"><span aria-hidden="true">&laquo;</span></asp:LinkButton>
                    </li>
                    <asp:Repeater ID="rptPaging" runat="server"
                        OnItemCommand="rptPaging_ItemCommand"
                        OnItemDataBound="rptPaging_ItemDataBound">
                        <ItemTemplate>
                            <li>
                                <asp:LinkButton ID="lbPaging" runat="server"
                                    CommandArgument='<%# Eval("PageIndex") %>'
                                    CommandName="newPage"
                                    Text='<%# Eval("PageText") %>'>
                                </asp:LinkButton>
                            </li>
                        </ItemTemplate>
                    </asp:Repeater>

                    <li class="next">
                        <asp:LinkButton ID="lbLast" runat="server" aria-label="Last"
                            OnClick="lbLast_Click"><span aria-hidden="true">&raquo;</span></asp:LinkButton>
                    </li>
                    <%--                    <li class="next">
                        <asp:LinkButton ID="lbLast" runat="server"
                            OnClick="lbLast_Click">Oldest</asp:LinkButton>
                    </li>--%>
                </ul>
            </nav>
        </div>       
    </fieldset>
</asp:Content>
