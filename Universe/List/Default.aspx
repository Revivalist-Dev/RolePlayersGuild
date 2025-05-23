<%@ Page Title="Universes on RPG" Language="C#" MasterPageFile="~/templates/2-Col With Authentication.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.Universe.List.Default" %>

<%@ MasterType VirtualPath="~/templates/2-Col With Authentication.master" %>
<%@ Register Src="~/templates/controls/UserNav.ascx" TagPrefix="uc1" TagName="UserNav" %>


<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" runat="server">
    <uc1:UserNav runat="server" ID="UserNav" />
    <div id="FilterByGenre" class="SearchFiltering FancyCheckList">
        <a class="FilterLabel btn btn-primary collapsed" data-toggle="collapse" href="#GenresPanel" aria-expanded="false" aria-controls="GenresPanel">Filter By Genre</a>
        <div id="GenresPanel" class="collapse">
            <asp:CheckBoxList ID="cblGenres" runat="server" RepeatLayout="UnorderedList" CssClass="FancyCheck" DataSourceID="sdsGenres" DataTextField="GenreName" DataValueField="GenreID" OnDataBound="cblGenres_DataBound" ></asp:CheckBoxList>
        </div>
        <asp:SqlDataSource ID="sdsGenres" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT * FROM [Genres] ORDER BY [GenreName]"></asp:SqlDataSource>
    </div>
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
            <li class="col-sm-4 col-xl-3 col-xl-offset-3"><a href="/My-Universes/Edit-Universe?Mode=New" class="btn btn-success">
                <span class="glyphicon glyphicon-plus"></span>
                New Universe</a></li>
        </ul>
    </div>
    <fieldset class="WritingContent">
        <legend>Universes</legend>
        <div class="alert alert-info">Below is a list of all Universes found within the RPG. You can use this screen to look for a universe you're interested in or create one.</div>
        
        <asp:Panel runat="server" ID="pnlSearchBar" CssClass="ControlPanel form-inline clearfix SearchTools" DefaultButton="btnSearch">
            <div class="ControlRow clearfix">
               
                <div class="form-group col-sm-10">
                    <asp:TextBox ID="txtLikeField" runat="server" CssClass="form-control" placeholder="Universe Name/ID"></asp:TextBox>
                </div>
                <div class="form-group col-sm-2">
                    <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary btn-block" OnClick="btnSearch_Click" />
                </div>
            </div>
        </asp:Panel>
        <div class="WritingContentList">
            <asp:Repeater ID="rptUniverses" runat="server" OnItemDataBound="rptUniverses_ItemDataBound">
                <ItemTemplate>
                    <div class="WritingContentBoxContainer col-xs-12">
                        <div class="WritingContentBox">
                            <a href="/Universe?id=<%# Eval("UniverseID") %>" class="WritingContentName"><%# Eval("UniverseName") %> &raquo;</a>
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
        <asp:SqlDataSource ID="sdsUniverseGenres" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT Universe_Genres.UniverseID, Genres.GenreName FROM Universe_Genres INNER JOIN Genres ON Universe_Genres.GenreID = Genres.GenreID WHERE (Universe_Genres.UniverseID = @UniverseID)">
            <SelectParameters>
                <asp:Parameter Name="UniverseID" />
            </SelectParameters>
        </asp:SqlDataSource>
    </fieldset>
</asp:Content>
