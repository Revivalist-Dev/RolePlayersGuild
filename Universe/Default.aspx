<%@ Page Title="" Language="C#" MasterPageFile="~/templates/1-Col.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.Universe.Default" %>

<%@ Register Src="~/templates/controls/CharacterListing.ascx" TagPrefix="uc1" TagName="CharacterListing" %>


<asp:Content ID="Content1" ContentPlaceHolderID="FullCol" runat="server">
    <script>
        function Closepopup() {
            $('#JoinWithCharacters').modal('hide');
        }
        function deactivateButton(theBtn) {
            $(theBtn).addClass("disabled");
            $(theBtn).text("Please Wait...");
        };
    </script>
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
    <div class="ButtonPanel clearfix">
        <div class="col-xl-3 col-sm-4 col-xs-12">
            <a href="/Universe/List/" class="btn btn-default">Back To Universes</a>
        </div>
        <div class="col-xl-3 col-sm-4 col-xs-12">
                <a id="aLeaveWhenBlocked" runat="server" visible="false" href="#" class="btn btn-danger" data-toggle="modal" data-target="#LeaveAsCharacters">Leave Universe</a>
        </div>
        <div class="col-xl-3 col-sm-4 col-xs-12">
                <asp:Button ID="btnOwnerWhenBlocked" runat="server" Text="Owner Profile" CssClass="btn btn-primary" OnClick="btnViewOwner_Click" Visible="false" />
        </div>
    </div>

    <asp:Panel ID="pnlContent" runat="server">
        <div class="SocialLinks">
            <a runat="server" id="aTwitterLink" href="https://twitter.com/share" class="twitter-share-button" data-text="#Roleplay with this #Universe!" data-hashtags="RolePlayersGuild">Tweet</a>
            <div class="fb-share-button" data-href="http://www.roleplayersguild.com/Character?id=<%= Request.QueryString["id"] %>" data-layout="button"></div>
        </div>
        <h1>
            <asp:Literal ID="litUniverseName" runat="server"></asp:Literal></h1>
        <asp:Literal ID="litGenreList" runat="server"></asp:Literal>
        <div class="ButtonPanel clearfix">
            <div class="col-xl-3 col-sm-4 col-xs-12">
                <a href="#" class="btn btn-success" data-toggle="modal" data-target="#JoinWithCharacters">Join Universe</a>
            </div>
            <div class="col-xl-3 col-sm-4 col-xs-12">
            </div>
            <div class="col-xl-3 col-sm-4 col-xs-12 col-xl-offset-3">
                <a href="#" class="btn btn-danger" data-toggle="modal" data-target="#LeaveAsCharacters">Leave Universe</a>
            </div>
            <div class="col-xl-3 col-sm-4 col-xs-12">
                <asp:Button ID="btnViewCharacters" runat="server" Text="Character List" CssClass="btn btn-primary" OnClick="btnViewCharacters_Click" />
            </div>
            <div class="col-xl-3 col-sm-4 col-xs-12">
                <asp:Button ID="btnViewChatRooms" runat="server" Text="Chat Room List" CssClass="btn btn-primary" OnClick="btnViewChatRooms_Click" />
            </div>
            <div class="col-xl-3 col-sm-4 col-xs-12">
                <asp:Button ID="btnViewStories" runat="server" Text="Story List" CssClass="btn btn-primary" OnClick="btnViewStories_Click" />
            </div>
             <div class="col-xl-3 col-sm-4 col-xs-12">
                <asp:Button ID="btnViewOwner" runat="server" Text="Owner Profile" CssClass="btn btn-primary" OnClick="btnViewOwner_Click" />
            </div>
        </div>
        <div runat="server" id="divUniverseAd">

            <script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
            <!-- UniversesMidPageAd -->
            <ins class="adsbygoogle"
                style="display: block"
                data-ad-client="ca-pub-1247828126747788"
                data-ad-slot="7953543314"
                data-ad-format="auto"></ins>
            <script>
                (adsbygoogle = window.adsbygoogle || []).push({});
            </script>
        </div>
        <div class="clearfix">
            <div class="col-lg-4">
                <div class="panel panel-primary">
                    <div class="panel-heading">
                        <h3 class="panel-title">Objects</h3>
                    </div>

                    <ul class="list-group ScrollingListGroup">
                        <asp:Repeater ID="rptItems" runat="server" DataSourceID="sdsItems">
                            <ItemTemplate>
                                <li class="list-group-item"><a href="/Article/?id=<%# Eval("ArticleID") %>"><%# Eval("ArticleTitle") %></a></li>
                            </ItemTemplate>
                        </asp:Repeater>
                    </ul>
                    <asp:SqlDataSource ID="sdsItems" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT * FROM [ArticlesForListing] WHERE CategoryID = 10 And UniverseID = @UniverseID ORDER BY [ArticleTitle]">
                        <SelectParameters>
                            <asp:QueryStringParameter Name="UniverseID" QueryStringField="id" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="panel panel-primary">
                    <div class="panel-heading">
                        <h3 class="panel-title">Creatures</h3>
                    </div>

                    <ul class="list-group ScrollingListGroup">
                        <asp:Repeater ID="rptCreatures" runat="server" DataSourceID="sdsCreatures">
                            <ItemTemplate>
                                <li class="list-group-item"><a href="/Article/?id=<%# Eval("ArticleID") %>"><%# Eval("ArticleTitle") %></a></li>
                            </ItemTemplate>
                        </asp:Repeater>
                    </ul>
                    <asp:SqlDataSource ID="sdsCreatures" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT * FROM [ArticlesForListing] WHERE CategoryID = 8 And UniverseID = @UniverseID ORDER BY [ArticleTitle]">
                        <SelectParameters>
                            <asp:QueryStringParameter Name="UniverseID" QueryStringField="id" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="panel panel-primary">
                    <div class="panel-heading">
                        <h3 class="panel-title">Areas</h3>
                    </div>

                    <ul class="list-group ScrollingListGroup">
                        <asp:Repeater ID="rptAreas" runat="server" DataSourceID="sdsAreas">
                            <ItemTemplate>
                                <li class="list-group-item"><a href="/Article/?id=<%# Eval("ArticleID") %>"><%# Eval("ArticleTitle") %></a></li>
                            </ItemTemplate>
                        </asp:Repeater>
                    </ul>
                    <asp:SqlDataSource ID="sdsAreas" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT * FROM [ArticlesForListing] WHERE CategoryID = 9 And UniverseID = @UniverseID ORDER BY [ArticleTitle]">
                        <SelectParameters>
                            <asp:QueryStringParameter Name="UniverseID" QueryStringField="id" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </div>
            </div>
        </div>
        <div id="divUniverseDescriptionContainer" runat="server" style="margin-bottom: 20px;">
            <asp:Literal ID="litUniverse" runat="server"></asp:Literal>
            <!--Spacer line.-->
        </div>

        <%--<uc1:CharacterListing runat="server" ID="CharacterListing" ScreenStatus="CharactersByUniverse" />--%>
    </asp:Panel>

    <asp:Panel runat="server" ClientIDMode="Static" DefaultButton="btnAddCharacters" CssClass="modal fade" ID="JoinWithCharacters" TabIndex="-1" role="dialog" aria-labelledby="JoinWithCharactersLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="JoinWithCharactersLabel">Select Characters</h4>
                </div>
                <div class="modal-body">
                    <p>Select the character(s) you would like to have added to this universe.</p>
                    <script type="text/javascript">
                        Sys.Application.add_load(BindEvents);
                        function BindEvents() {
                            $('[data-toggle=tooltip]').tooltip();
                        }
                    </script>
                    <asp:Panel ID="pnlYourCharacters" runat="server" class="SelectableCharacterList UserSearchResults">
                        <asp:CheckBoxList ID="cblYourCharacters" runat="server" RepeatLayout="UnorderedList" DataSourceID="sdsYourCharacters" DataValueField="CharacterID" DataTextField="CharacterDisplayName">
                        </asp:CheckBoxList>
                        <asp:SqlDataSource ID="sdsYourCharacters" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT [CharacterID], [CharacterDisplayName] FROM [Characters] WHERE ([UserID] = @UserID) And CharacterID not in (Select CharacterID From Character_Universes Where UniverseID = @UniverseID)  ORDER BY [CharacterDisplayName]">
                            <SelectParameters>
                                <asp:SessionParameter Name="UserID" SessionField="UserID" Type="Int32" />
                                <asp:QueryStringParameter Name="UniverseID" QueryStringField="id" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </asp:Panel>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnAddCharacters" runat="server" Text="Add Selected Characters" CssClass="btn btn-success" OnClientClick="deactivateButton(this); return true;" OnClick="btnAddCharacters_Click" />
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </asp:Panel>
    <asp:Panel runat="server" ClientIDMode="Static" DefaultButton="btnRemoveCharacters" CssClass="modal fade" ID="LeaveAsCharacters" TabIndex="-1" role="dialog" aria-labelledby="LeaveAsCharactersLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="LeaveAsCharactersLabel">Select Characters</h4>
                </div>
                <div class="modal-body">
                    <p>Select the character(s) you would like to have added to this universe.</p>
                    <script type="text/javascript">
                        Sys.Application.add_load(BindEvents);
                        function BindEvents() {
                            $('[data-toggle=tooltip]').tooltip();
                        }
                    </script>
                    <asp:Panel ID="pnlYourJoinedCharacters" runat="server" class="SelectableCharacterList RemovableCharacters">
                        <asp:CheckBoxList ID="cblYourJoinedCharacters" runat="server" RepeatLayout="UnorderedList" DataSourceID="sdsYourJoinedCharacters" DataValueField="CharacterID" DataTextField="CharacterDisplayName">
                        </asp:CheckBoxList>
                        <asp:SqlDataSource ID="sdsYourJoinedCharacters" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT [CharacterID], [CharacterDisplayName] FROM [Characters] WHERE ([UserID] = @UserID) And CharacterID in (Select CharacterID From Character_Universes Where UniverseID = @UniverseID) ORDER BY [CharacterDisplayName]">
                            <SelectParameters>
                                <asp:SessionParameter Name="UserID" SessionField="UserID" Type="Int32" />
                                <asp:QueryStringParameter Name="UniverseID" QueryStringField="id" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </asp:Panel>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnRemoveCharacters" runat="server" Text="Remove Selected Characters" CssClass="btn btn-danger" OnClientClick="deactivateButton(this); return true;" OnClick="btnRemoveCharacters_Click" />
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </asp:Panel>
</asp:Content>


