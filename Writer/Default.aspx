<%@ Page Title="" Language="C#" MasterPageFile="~/templates/1-Col.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.Writer.Default" %>

<%@ Register Src="~/templates/controls/CharacterListing.ascx" TagPrefix="uc1" TagName="CharacterListing" %>


<asp:Content ID="Content1" ContentPlaceHolderID="FullCol" runat="server">
    <div id="fb-root"></div>
    <script>(function (d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) return;
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.5";
    fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));</script>
    <script>!function (d, s, id) { var js, fjs = d.getElementsByTagName(s)[0], p = /^http:/.test(d.location) ? 'http' : 'https'; if (!d.getElementById(id)) { js = d.createElement(s); js.id = id; js.src = p + '://platform.twitter.com/widgets.js'; fjs.parentNode.insertBefore(js, fjs); } }(document, 'script', 'twitter-wjs');</script>
    <asp:Panel ID="pnlMessage" runat="server" ViewStateMode="Disabled" Visible="false" role="alert">
        <asp:Literal ID="litMessage" runat="server" ViewStateMode="Disabled"></asp:Literal>
    </asp:Panel>

    <div class="CharacterTools clearfix">
        <asp:HyperLink runat="server" ID="lnkBlockUser" href="#" class="btn btn-danger pull-right" data-toggle="modal" data-target="#BlockConfirmation">Block This User</asp:HyperLink>
        <asp:HyperLink runat="server" ID="lnkUnblockUser" href="#" class="btn btn-success pull-right" data-toggle="modal" data-target="#UnblockConfirmation" Visible="false">Unblock This User</asp:HyperLink>
    </div>

    <div class="SocialLinks">
        <a runat="server" id="aTwitterLink" href="https://twitter.com/share" class="twitter-share-button" data-text="Check out this awesome #writer on RPG!" data-hashtags="RolePlayersGuild">Tweet</a>
        <div class="fb-share-button" data-href="http://www.roleplayersguild.com/Character?id=<%= Request.QueryString["id"] %>" data-layout="button"></div>
    </div>



    <div class="panel panel-primary">
        <div class="panel-heading">
            <h1 class="panel-title">
                About <asp:Literal ID="litCharacterName" runat="server"></asp:Literal>
            </h1>
            <span runat="server" id="pUserOnline" class="UserOnline small">Currently Online
            </span>
        </div>
        <div class="panel-body" data-linkify><asp:Literal ID="litAboutMe" runat="server"></asp:Literal></div>
    </div>
    <div runat="server" id="WriterBadges" class="panel panel-primary">
        <div class="panel-heading">
            <h3 class="panel-title">Writer's Badges</h3>
        </div>
        <script>
            $(function () {
                $('.UserBadge').popover();
            })
        </script>
        <div class="UserBadges panel-body">
            <asp:Repeater ID="rptUserBadges" runat="server" DataSourceID="sdsUserBadges">
                <ItemTemplate>
                    <input type="image" class="UserBadge" src="<%# Eval("BadgeImageURL") %>" title="<%# Eval("BadgeName") %>" data-container="body" data-placement="bottom" data-trigger="focus" data-toggle="popover" data-content="<%# Eval("BadgeDescription") %>" onclick="return false;" />
                    <%--<button type="button" class="UserBadgeBtn" title='<%# Eval("BadgeName") %>' data-toggle="popover" data-content='<%# Eval("BadgeDescription") %>'>
                        <img class="UserBadge" src='<%# Eval("BadgeImageURL") %>' /></button>--%>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
    <asp:SqlDataSource ID="sdsUserBadges" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT Badges.BadgeName, Badges.BadgeImageURL, Badges.BadgeDescription FROM Badges INNER JOIN User_Badges ON Badges.BadgeID = User_Badges.BadgeID WHERE (User_Badges.UserID = @ParamOne) ORDER BY SortOrder, BadgeName">
        <SelectParameters>
            <asp:QueryStringParameter Name="ParamOne" QueryStringField="id" />
        </SelectParameters>
    </asp:SqlDataSource>

    <div runat="server" id="WriterArticlesListing" class="panel panel-primary">
        <div class="panel-heading">
            <h3 class="panel-title">Writer's Articles</h3>
        </div>

        <ul class="list-group">
            <asp:Repeater ID="rptArticles" runat="server" DataSourceID="sdsArticles" OnItemDataBound="rptArticles_ItemDataBound">
                <ItemTemplate>
                    <li class="list-group-item"><a href="/Article/?id=<%# Eval("ArticleID") %>"><%# Eval("ArticleTitle") %></a> - (<%# Eval("ContentRating") %>)
                            <asp:Repeater ID="rptGenres" runat="server">
                                <HeaderTemplate>- </HeaderTemplate>
                                <ItemTemplate><%# Eval("GenreName") %></ItemTemplate>
                                <SeparatorTemplate>, </SeparatorTemplate>
                            </asp:Repeater>
                    </li>
                </ItemTemplate>
            </asp:Repeater>
        </ul>
        <asp:SqlDataSource ID="sdsArticles" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT * FROM [ArticlesForListing] Where (CategoryID <> 8 AND CategoryID <> 9 AND CategoryID <> 10) AND OwnerUserID = @UserID AND IsPrivate = 0 ORDER BY [ArticleTitle]">
            <SelectParameters>
                <asp:QueryStringParameter Name="UserID" QueryStringField="id" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sdsGenres" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT Article_Genres.ArticleID, Genres.GenreName FROM Article_Genres INNER JOIN Genres ON Article_Genres.GenreID = Genres.GenreID WHERE (Article_Genres.ArticleID = @ArticleID)">
            <SelectParameters>
                <asp:Parameter Name="ArticleID" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>

    <uc1:CharacterListing runat="server" ID="CharacterListing" ScreenStatus="CharactersByUser" />

    <div class="modal fade" id="BlockConfirmation" tabindex="-1" role="dialog" aria-labelledby="BlockConfirmationLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content alert-danger">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="BlockConfirmationLabel">Are you sure you want to block this user?</h4>
                </div>
                <div class="modal-body">
                    <p>If you block this user, they will no longer be able to contact you in anyway.</p>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnBlockUser" runat="server" Text="Block User" CssClass="btn btn-danger" OnClick="btnBlockUser_Click" />
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="UnblockConfirmation" tabindex="-1" role="dialog" aria-labelledby="UnblockConfirmationLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content alert-success">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="UnblockConfirmationLabel">Are you sure you want to unblock this user?</h4>
                </div>
                <div class="modal-body">
                    <p>If you unblock this user, they will then be able to contact you again.</p>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnUnblockUser" runat="server" Text="Unblock User" CssClass="btn btn-success" OnClick="btnUnblockUser_Click" />
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
