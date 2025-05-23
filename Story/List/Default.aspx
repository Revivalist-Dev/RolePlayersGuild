<%@ Page Title="Stories on RPG" Language="C#" MasterPageFile="~/templates/2-Col With Authentication.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.Story.List.Default" %>

<%@ MasterType VirtualPath="~/templates/2-Col With Authentication.master" %>
<%@ Register Src="~/templates/controls/UserNav.ascx" TagPrefix="uc1" TagName="UserNav" %>


<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" runat="server">
    <uc1:UserNav runat="server" ID="UserNav" />
    <%--    <div class="panel panel-primary">
        <div class="panel-heading">
            <h3 class="panel-title">Filter By Genre</h3>
        </div>
        <div id="GenresPanel" class="panel-body">
            <asp:CheckBoxList ID="" runat="server" RepeatLayout="UnorderedList" CssClass="FancyCheck" DataSourceID="sdsGenres" DataTextField="GenreName" DataValueField="GenreID" OnDataBound="cblGenres_DataBound"></asp:CheckBoxList>
        </div>
        <asp:SqlDataSource ID="" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT * FROM [Genres] ORDER BY [GenreName]"></asp:SqlDataSource>
    </div>--%>
    <asp:Button ID="btnUniverseFilter" runat="server" Text="Search By Universe" CssClass="btn btn-primary btn-block" OnClick="btnUniverseFilter_Click" />
    <br />
    <div class="form-group">
        <label for="cblGenres">Filter by Genres</label>
        <div class="FancyCheckList">
            <asp:CheckBoxList ID="cblGenres" runat="server" RepeatLayout="UnorderedList" DataSourceID="sdsGenres" DataTextField="GenreName" DataValueField="GenreID" CssClass="FancyCheck" OnDataBound="cblGenres_DataBound"></asp:CheckBoxList>
            <asp:SqlDataSource ID="sdsGenres" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT * FROM [Genres] ORDER BY [GenreName]"></asp:SqlDataSource>
        </div>
    </div>
    <div class="form-group">
        <label for="cblRatings">Filter by Rating</label>
        <div class="FancyCheckList">
            <asp:CheckBoxList ID="cblRatings" runat="server" RepeatLayout="UnorderedList" CssClass="FancyCheck">
                <asp:ListItem Value="3" Text="Show Adult Content"></asp:ListItem>
            </asp:CheckBoxList>
        </div>
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
            <li class="col-sm-4 col-xl-3 col-xl-offset-3"><a href="/My-Stories/Edit-Story?Mode=New" class="btn btn-success">
                <span class="glyphicon glyphicon-plus"></span>
                New Story</a></li>
        </ul>
    </div>
    <fieldset class="WritingContent">
        <legend><asp:Literal runat="server" id="litListingType"></asp:Literal></legend>
        <div class="alert alert-info">Below is a list of all Stories found within the RPG. You can use this screen to look for a Story you're interested in or create one.</div>

        <asp:Panel runat="server" ID="pnlSearchBar" CssClass="ControlPanel form-inline clearfix SearchTools" DefaultButton="btnSearch">
            <div class="ControlRow clearfix row">
                <div class="form-group col-sm-10">
                    <asp:TextBox ID="txtLikeField" runat="server" CssClass="form-control" placeholder="Story Name/ID"></asp:TextBox>
                </div>
                <div class="form-group col-sm-2">
                    <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary btn-block" OnClick="btnSearch_Click" />
                </div>
            </div>
        </asp:Panel>
        <div class="WritingContentList">
            <asp:Repeater ID="rptStories" runat="server" OnItemDataBound="rptStories_ItemDataBound">
                <ItemTemplate>
                    <div class="row">
                        <div class="WritingContentBoxContainer col-xs-12">
                            <div class="WritingContentBox">
                                <a href="/Story?id=<%# Eval("StoryID") %>" class="WritingContentName"><%# Eval("StoryTitle") %> &raquo;</a>
                                <div class="WritingContentDetails">
                                    <ul class="Info">
                                        <li><span>Rating:</span> <%# Eval("ContentRating") %></li>
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
        <asp:SqlDataSource ID="sdsStoryGenres" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT Story_Genres.StoryID, Genres.GenreName FROM Story_Genres INNER JOIN Genres ON Story_Genres.GenreID = Genres.GenreID WHERE (Story_Genres.StoryID = @StoryID)">
            <SelectParameters>
                <asp:Parameter Name="StoryID" />
            </SelectParameters>
        </asp:SqlDataSource>
    </fieldset>
</asp:Content>
