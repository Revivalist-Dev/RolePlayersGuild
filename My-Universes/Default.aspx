<%@ Page Title="My Universes on RPG" Language="C#" MasterPageFile="~/templates/2-Col With Authentication.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.MyUniverses.Default" %>

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
            <li class="col-sm-4 col-xl-3 col-xl-offset-3"><a href="/My-Universes/Edit-Universe?Mode=New" class="btn btn-success">
                <span class="glyphicon glyphicon-plus"></span>
                New Universe</a></li>
        </ul>
    </div>
    <fieldset class="WritingContent">
        <legend>My Universes</legend>        
        <div class="WritingContentList">
            <asp:Repeater ID="rptUniverses" runat="server" DataSourceID="sdsUniverses" OnItemDataBound="rptUniverses_ItemDataBound">
                <ItemTemplate>
                    <div class="WritingContentBoxContainer col-xs-12">
                        <div class="WritingContentBox">
                            <a href="/My-Universes/Edit-Universe?Mode=Edit&id=<%# Eval("UniverseID") %>" class="WritingContentName"><%# Eval("UniverseName") %> &raquo;</a>
                            <div class="WritingContentDetails">
                                <ul class="Info">
                                    <li><span>Source:</span> <%# Eval("SourceType") %></li>
                                    <li><span>Rating:</span> <%# Eval("ContentRating") %></li>
                                    <li><span>Characters:</span> <%# Eval("CharacterCount") %></li>
                                    <li><span>Chat Rooms:</span> <%# Eval("ChatRoomCount") %></li>
                                </ul>
                                <ul class="Genres">
                                    <asp:Repeater ID="rptGenres" runat="server">
                                        <ItemTemplate>
                                            <li><%# Eval("GenreName") %></li>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </ul>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        <asp:SqlDataSource ID="sdsUniverses" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT * FROM [UniversesForListing] WHERE ([StatusID] = 2) AND UniverseOwnerID = @UserID Order By UniverseName">
            <SelectParameters>
                <asp:SessionParameter Name="UserID" SessionField="UserID" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sdsGenres" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT Universe_Genres.UniverseID, Genres.GenreName FROM Universe_Genres INNER JOIN Genres ON Universe_Genres.GenreID = Genres.GenreID WHERE (Universe_Genres.UniverseID = @UniverseID)">
            <SelectParameters>
                <asp:Parameter Name="UniverseID" />
            </SelectParameters>
        </asp:SqlDataSource>
    </fieldset>
</asp:Content>
