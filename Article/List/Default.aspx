<%@ Page Title="Articles on RPG" Language="C#" MasterPageFile="~/templates/2-Col With Authentication.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.Article.List.Default" %>

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
            <li class="col-sm-4 col-xl-3 col-xl-offset-3"><a href="/My-Articles/Edit-Article?Mode=New" class="btn btn-success">
                <span class="glyphicon glyphicon-plus"></span>
                New Article</a></li>
        </ul>
    </div>
    <fieldset class="WritingContent">
        <legend>Articles</legend>
        <div class="alert alert-info">Below is a list of all Articles found within the RPG. You can use this screen to look for an Articles you're interested in or create one.</div>
        <div class="WritingContentList">
            <asp:Repeater ID="rptArticles" runat="server" OnItemDataBound="rptArticles_ItemDataBound">
                <ItemTemplate>
                    <div class="WritingContentBoxContainer col-xs-12">
                        <div class="WritingContentBox">
                            <a href="/Article?id=<%# Eval("ArticleID") %>" class="WritingContentName"><%# Eval("ArticleTitle") %> &raquo;</a>
                            <div class="WritingContentDetails">
                                <ul class="Info">
                                    <li><span>Rating:</span> <%# Eval("ContentRating") %></li>
                                    <li><span>Category:</span> <%# Eval("CategoryName") %></li>
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

                </ul>
            </nav>
            <asp:SqlDataSource ID="sdsGenres" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT Article_Genres.ArticleID, Genres.GenreName FROM Article_Genres INNER JOIN Genres ON Article_Genres.GenreID = Genres.GenreID WHERE (Article_Genres.ArticleID = @ArticleID)">
                <SelectParameters>
                    <asp:Parameter Name="ArticleID" />
                </SelectParameters>
            </asp:SqlDataSource>
        </div>
    </fieldset>
</asp:Content>
