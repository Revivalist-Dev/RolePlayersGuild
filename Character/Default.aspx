<%@ Page Title="" Language="C#" MasterPageFile="~/templates/2-Col.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.Character.Default" %>

<asp:Content ID="Content2" ContentPlaceHolderID="cphLeftCol" runat="server">
    <div id="fb-root"></div>
    <script>(function (d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) return;
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.5";
    fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));</script>
    <script>!function (d, s, id) { var js, fjs = d.getElementsByTagName(s)[0], p = /^http:/.test(d.location) ? 'http' : 'https'; if (!d.getElementById(id)) { js = d.createElement(s); js.id = id; js.src = p + '://platform.twitter.com/widgets.js'; fjs.parentNode.insertBefore(js, fjs); } }(document, 'script', 'twitter-wjs');</script>
   
     
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
        <div class="modal fade" id="ReviewConfirmation" tabindex="-1" role="dialog" aria-labelledby="ReviewConfirmationLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content alert-danger">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="ReviewConfirmationLabel">Are you sure you want to mark this character for review?</h4>
                </div>
                <div class="modal-body">
                    <p>Marking this user for review will lock their profile down and put them in the Under Review screen on the Admin Console.</p>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnMarkForReview" runat="server" Text="Mark For Review" CssClass="btn btn-danger" OnClick="btnMarkForReview_Click" />
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                </div>
            </div>
        </div>
    </div>

    <div itemscope itemtype="http://schema.org/CreativeWork" class="CharacterSideBar">
        <div class="SocialLinks">
            <a runat="server" id="aTwitterLink" href="https://twitter.com/share" class="twitter-share-button" data-text="Check out this awesome character on RPG!" data-hashtags="RolePlayersGuild">Tweet</a>
            <div class="fb-share-button" data-href="http://www.roleplayersguild.com/Character?id=<%= Request.QueryString["id"] %>" data-layout="button"></div>
        </div>
        <div itemprop="character" itemscope itemtype="http://schema.org/Person" itemid="CharacterDetails">
            <asp:Panel ID="pnlMatureContentWarning" runat="server" CssClass="alert alert-danger" Visible="false">
                <p>This character has been flagged for mature content. Please understand that this profile or future interactions with this character may include content considered appropriate only for audiences who are 18 or older.</p>
            </asp:Panel>
            <a href="/Gallery?id=<%= Request.QueryString["id"].ToString() %>">
                <asp:Image ID="imgDisplayImage" runat="server" CssClass="img-responsive img-rounded lazyload" ImageUrl="https://s3.amazonaws.com/roleplayersguild/CharacterImages/NewCharacter.png" itemprop="image" /></a>
        </div>
        <div class="OOCInfo" runat="server" id="divCharacterOOC">
            <p runat="server" id="pUserOnline" class="UserOnline">
                Currently Online
            </p>
            <p class="col-sm-6">
                <strong>Last Login: </strong>
                <asp:Literal ID="litLastLogin" runat="server"></asp:Literal>
            </p>
            <p class="col-sm-6">
                <strong>Contact Pref.: </strong>
                <asp:Literal ID="litLFRP" runat="server"></asp:Literal>
            </p>
            <p class="col-sm-6">
                <strong>Source: </strong>
                <asp:Literal ID="litOriginality" runat="server"></asp:Literal>
            </p>

            <p class="col-sm-6">
                <strong>Post Length: </strong>
                <asp:Literal ID="litPostLengthMin" runat="server"></asp:Literal>
                <asp:Literal ID="litPostLengthMax" runat="server"></asp:Literal>
            </p>

            <p class="col-sm-6">
                <strong>Literacy Level: </strong>
                <asp:Literal ID="litLiteracyLevel" runat="server"></asp:Literal>
            </p>
            <p class="col-sm-6" id="pErotica" runat="server">
                <strong>Erotica: </strong>
                <asp:Literal ID="litErotica" runat="server"></asp:Literal>
            </p>
            <p class="col-sm-12">
                <strong>Genres: </strong>
                <asp:Literal ID="litGenreList" runat="server"></asp:Literal>
            </p>
        </div>
        <div class="ButtonPanel clearfix" runat="server" id="divCharacterControls">
            <ul>
                <li runat="server" id="liAdminConsole" class="col-sm-6" visible="false">
                    <a href="/Admin/Characters?id=<%= Request.QueryString["id"].ToString() %>" class="btn btn-primary staff">Admin Console</a>
                </li>
                <li runat="server" id="liMarkForReview" class="col-sm-6" visible="false">
                    <asp:HyperLink runat="server" ID="lnkMarkForReview" href="#" class="btn btn-danger" data-toggle="modal" data-target="#ReviewConfirmation">Mark For Review</asp:HyperLink>
                </li>
                <li class="col-sm-6">
                    <asp:HyperLink ID="lnkAddToThread" runat="server" CssClass="btn btn-primary">Message</asp:HyperLink>
                </li>
                <li class="col-sm-6">
                    <a href="/Gallery?id=<%= Request.QueryString["id"].ToString() %>" class="btn btn-default">View Gallery</a>
                </li>
                <li class="col-sm-6">
                    <asp:HyperLink ID="lnkWriterLink" runat="server" CssClass="btn btn-default">View Writer</asp:HyperLink>
                </li>
            </ul>
        </div>
         <div class="ButtonPanel clearfix" runat="server" id="divStaffControls" visible="false">
            <ul>
                <li class="col-sm-12">
                    <a href="/Report/" class="btn btn-primary">Contact Staff</a>
                </li>                
            </ul>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="cphRightCol" runat="server">

    <asp:Panel ID="pnlMessage" runat="server" ViewStateMode="Disabled" Visible="false" role="alert">
        <asp:Literal ID="litMessage" runat="server" ViewStateMode="Disabled"></asp:Literal>
    </asp:Panel>

    <div class="CharacterTools clearfix">
        <asp:HyperLink runat="server" ID="lnkBlockUser" href="#" class="btn btn-danger pull-right" data-toggle="modal" data-target="#BlockConfirmation">Block This User</asp:HyperLink>
        <asp:HyperLink runat="server" ID="lnkUnblockUser" href="#" class="btn btn-success pull-right" data-toggle="modal" data-target="#UnblockConfirmation" Visible="false">Unblock This User</asp:HyperLink>
    </div>
    <div runat="server" id="divCharacterDetails" itemprop="character" itemscope itemtype="http://schema.org/Person" itemid="CharacterDetails">
        <h1 itemprop="name">
            <asp:Literal ID="litCharacterName" runat="server"></asp:Literal></h1>
        <%--<a href="#" runat="server" id="aCharacterName"><asp:Literal ID="litCharacterName" runat="server"></asp:Literal></a></h1>--%>
        <p>
            <strong>Full Name: </strong>
            <asp:Label ID="lblGivenName" runat="server" itemprop="givenName"></asp:Label>
            <asp:Label ID="lblAdditionalName" runat="server" itemprop="additionalName"></asp:Label>
            <asp:Label ID="lblFamilyName" runat="server" itemprop="familyName"></asp:Label>
        </p>
        <p>
            <strong>Gender: </strong>
            <asp:Label ID="lblGender" runat="server" itemprop="gender"></asp:Label>
        </p>
        <p>
            <strong>Sexual Orientation: </strong>
            <asp:Label ID="lblSexualOrientation" runat="server"></asp:Label>
        </p>
        <p>
            <strong>Universe(s):</strong>
            <asp:Repeater ID="rptCharacterUniverses" runat="server" DataSourceID="sdsCharacterUniverses">
                <ItemTemplate><a href="/Universe/?id=<%# Eval("UniverseID") %>"><%# Eval("UniverseName") %></a></ItemTemplate>
                <SeparatorTemplate>, </SeparatorTemplate>
            </asp:Repeater>
            <asp:SqlDataSource ID="sdsCharacterUniverses" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT Character_Universes.UniverseID, Universes.UniverseName FROM Character_Universes INNER JOIN Universes ON Character_Universes.UniverseID = Universes.UniverseID WHERE (Character_Universes.CharacterID = @CharacterID) ORDER BY Universes.UniverseName">
                <SelectParameters>
                    <asp:QueryStringParameter Name="CharacterID" QueryStringField="id" />
                </SelectParameters>
            </asp:SqlDataSource>
        </p>
    </div>
    <div id="divOriginStory" runat="server">
        <asp:Literal ID="litBackground" runat="server"></asp:Literal>
    </div>

</asp:Content>

