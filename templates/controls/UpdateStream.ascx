<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UpdateStream.ascx.cs" Inherits="RolePlayersGuild.templates.controls.UpdateStream" %>
<%@ Register Src="~/templates/controls/VotePrompt.ascx" TagPrefix="uc1" TagName="VotePrompt" %>
<%@ Register Src="~/templates/controls/SendAsChanger.ascx" TagPrefix="uc1" TagName="SendAsChanger" %>


<script>
    function Closepopups() {
        $('#MyCharacters').modal('hide');
    }

    //var xPos, yPos, currentFirstDivHtml;
    //var prm = Sys.WebForms.PageRequestManager.getInstance();

    //function BeginRequestHandler(sender, args) {
    //    if ($('.StreamPosts') != null) {
    //        xPos = $('.StreamPosts').scrollLeft();
    //        yPos = $('.StreamPosts').scrollTop();
    //        currentFirstDivHtml = $('.StreamPosts').find('.Post').first().html();
    //    }
    //}
    //function EndRequestHandler(sender, args) {
    //    if ($('.StreamPosts') != null) {
    //        if (yPos != 0) {
    //            var newFirstDivHtml = $('.StreamPosts').find('.Post').first();
    //            if (currentFirstDivHtml != newFirstDivHtml.html()) {
    //                yPos += newFirstDivHtml.height() + 21;
    //            }
    //            $('.StreamPosts').scrollLeft(xPos);
    //            $('.StreamPosts').scrollTop(yPos);
    //        }
    //    }
    //}
    //prm.add_beginRequest(BeginRequestHandler);
    //prm.add_endRequest(EndRequestHandler);
</script>


<script>
    function deactivateButton(theBtn) {
        $(theBtn).addClass("disabled");
        $(theBtn).prop('value', "Please Wait...");
        $(theBtn).prop("disabled", true);

        //$(theBtn).hide();
    };

</script>
<asp:Panel runat="server" ID="pnlStreamContainer" CssClass="UpdateStream" DefaultButton="btnPostToStream">

    <asp:Panel ID="pnlLockOutMessage" runat="server" CssClass="alert alert-danger" Visible="false">
        <p>You have been locked out of the stream for 30 minutes. If you feel this was done in error, please use the report feature.</p>
    </asp:Panel>
    <div runat="server" id="divSubmitPost">
        <asp:UpdatePanel ID="UpdatePanel2" runat="server">
            <ContentTemplate>
                <div class="MakePost clearfix">
                    <div class="col-xs-2 PostAsImage">
                        <%--<a runat="server" id="aSendAs" href="#" data-toggle="modal" data-target="#MyCharacters" class="CharacterImage"></a>--%>
                        <uc1:SendAsChanger runat="server" ID="SendAsChanger" />
                    </div>
                    <div class="col-xs-10 PostText">
                        <%--<asp:TextBox ID="txtPostToStream" runat="server" TextMode="MultiLine" CssClass="form-control" Rows="4" placeholder="No HTML..." MaxLength="475" onkeyDown="return checkTextAreaMaxLength(this,event,'475');"></asp:TextBox>--%>

                        <asp:TextBox ID="txtPostToStream" runat="server" ClientIDMode="Static" TextMode="MultiLine" CssClass="form-control" Rows="4" placeholder="This area is an IC area. OOC chatter is allowed, but to avoid confusion, please make sure it is properly labeled. Thank you." required ValidateRequestMode="Disabled" TabIndex="20"></asp:TextBox>

                    </div>
                </div>
                <div class="ButtonPanel clearfix">
                    <div class="col-xl-3 col-sm-4 col-xs-12">
                        <a href="#" class="btn btn-info" data-toggle="modal" data-target="#WhereAreWeToday" tabindex="23">Where are we today?</a>
                    </div>
                    <div class="col-xl-3 col-sm-4 col-xs-12">
                        <asp:Button ID="btnRefreshStream" runat="server" Text="Refresh Stream" CssClass="btn btn-default" OnClick="btnRefreshStream_Click" OnClientClick="__doPostBack;deactivateButton(this);" UseSubmitBehavior="false" formnovalidate />
                    </div>
                    <div class="col-xl-3 col-sm-4 col-xs-12">
                        <asp:Button ID="btnPostToStream" runat="server" Text="Submit Post" CssClass="btn btn-primary" OnClick="btnPostToStream_Click" OnClientClick="__doPostBack;deactivateButton(this);" UseSubmitBehavior="false" TabIndex="21" />
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>

    <uc1:VotePrompt runat="server" ID="VotePrompt" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnPostToStream" />
            <asp:AsyncPostBackTrigger ControlID="btnRefreshStream" />
        </Triggers>
        <ContentTemplate>

            <%--<asp:Timer ID="Timer1" runat="server" Interval="5000" OnTick="Timer1_Tick"></asp:Timer>--%>
            <div class="StreamPosts">
                <asp:Repeater ID="rptSteamPosts" runat="server" DataSourceID="sdsStreamPosts" OnItemDataBound="rptSteamPosts_ItemDataBound">
                    <ItemTemplate>
                        <div class="Post">

                            <div class="PostDetails clearfix">
                                <div class="Creator col-xs-2">
                                    <asp:HyperLink ID="lnkCreator" runat="server" CssClass="CharacterImage"></asp:HyperLink>
                                </div>
                                <div class="Content col-xs-10">
                                    <strong class="CharacterName"><a class="<%# ColorName(Eval("TypeID")) %>" href="/Character?id=<%# Eval("StreamPostMadeByCharacterID") %>"><%# Eval("CharacterDisplayName") %></a><span class="TimeStamp"> <%# ShowTimeAgo(Eval("StreamPostCreatedDateTime").ToString()) %> </span></strong>
                                    <span data-linkify><%# Eval("StreamPostContent") %></span>
                                </div>
                            </div>
                            <div class="Options"></div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:SqlDataSource ID="sdsStreamPosts" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT Top 100 * FROM [StreamUpdatesWithDetails] WHERE ( UserID NOT IN (SELECT UserBlocked FROM User_Blocking WHERE (UserBlockedBy = @UserID)) AND UserID NOT IN (SELECT UserBlockedBy FROM User_Blocking AS User_Blocking WHERE (UserBlocked = @UserID)) ) ORDER BY [StreamPostCreatedDateTime] DESC">
                    <SelectParameters>
                        <asp:SessionParameter Name="UserID" SessionField="UserID" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Panel>


<div class="modal fade" id="WhereAreWeToday" tabindex="-1" role="dialog" aria-labelledby="WhereAreWeTodayLabel" runat="server" clientidmode="Static">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="WhereAreWeTodayLabel">Where are we today?</h4>
            </div>
            <div class="modal-body" style="max-height: 300px; overflow: auto;">
                <p class="alert alert-ooc">Ready for a change of scenery? Use the Report Feature to let us know and suggest a new setting!</p>
                <asp:Literal ID="litWhereWeAre" runat="server"></asp:Literal>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
<%--<div class="modal fade" id="MyCharacters" tabindex="-1" role="dialog" aria-labelledby="MyCharactersLabel">
    <div class="modal-dialog modal-sm">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="MyCharactersLabel">Switch To...</h4>
            </div>
            <div class="modal-body SwitchToCharacterList">
                <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <asp:Repeater ID="rptMyCharacters" runat="server" DataSourceID="sdsMyCharacters" OnItemDataBound="rptMyCharacters_ItemDataBound" OnItemCommand="rptMyCharacters_ItemCommand">
                            <ItemTemplate>
                                <asp:Button ID="btnCharacter" runat="server" Text="Switch To..." CssClass="btn btn-primary btn-sm" formnovalidate />
                            </ItemTemplate>
                        </asp:Repeater>

                        <asp:SqlDataSource ID="sdsMyCharacters" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT [CharacterDisplayName], [CharacterID] FROM [Characters] WHERE ([UserID] = @UserID) ORDER BY [CharacterID]">
                            <SelectParameters>
                                <asp:SessionParameter Name="UserID" SessionField="UserID" Type="Int32" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
            </div>
        </div>
    </div>
</div>--%>
