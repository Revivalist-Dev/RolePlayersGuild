<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ThreadListing.ascx.cs" Inherits="RolePlayersGuild.templates.controls.ThreadListing" %>
<%@ Register Src="~/templates/controls/VotePrompt.ascx" TagPrefix="uc1" TagName="VotePrompt" %>

<uc1:VotePrompt runat="server" ID="VotePrompt" />


<asp:UpdatePanel ID="UpdatePanel1" runat="server" ChildrenAsTriggers="true">

    <ContentTemplate>
        <div class="ButtonPanel clearfix">
            <div class="col-xl-3 col-sm-4 col-xs-12">
            </div>
            <div class="col-xl-3 col-sm-4 col-xs-12 col-xl-offset-3">
                <asp:Button ID="btnMarkAsUnread" runat="server" Text="Mark as Unread" CssClass="btn btn-warning" OnClick="btnMarkAsUnread_Click" OnClientClick="deactivateButton(this);" />
            </div>
            <div class="col-xl-3 col-sm-4 col-xs-12">
                <a href="/My-Threads/Edit-Thread?Mode=NewThread" class="btn btn-success"><span class="glyphicon glyphicon-plus"></span>
                    New Thread</a>
            </div>
        </div>
        <fieldset>
            <legend>
                <asp:Literal ID="litFolderName" runat="server"></asp:Literal>
            </legend>
            <script type="text/javascript">
                Sys.Application.add_load(BindEvents);
                function BindEvents() {
                    $('[data-toggle=tooltip]').tooltip();
                }

                function deactivateButton(theBtn) {
                    setTimeout(function () {
                        $(theBtn).prop("disabled", true);
                        $(theBtn).addClass("disabled");
                        $(theBtn).prop("value", "Please Wait...");
                    }, 100);
                };
            </script>
            <asp:Panel runat="server" ID="pnlThreadListing" Visible="false" class="ThreadListing">
                <asp:Repeater ID="rptThreadListing" runat="server" OnItemDataBound="rptThreadListing_ItemDataBound" OnItemCommand="rptThreadListing_ItemCommand" OnItemCreated="rptThreadListing_ItemCreated">
                    <%--DataSourceID="sdsThreads"--%>
                    <ItemTemplate>
                        <asp:HiddenField ID="hdnThreadID" runat="server" />
                        <asp:Panel runat="server" ID="pnlThread" ClientIDMode="Predictable">
                            <div class="Details">
                                <a href="/My-Threads/View-Thread?ThreadID=<%# Eval("ThreadID") %>" class="Title"><%# Eval("ThreadTitle") %></a>
                                <span class="Status">
                                    <asp:Literal ID="litReadStatus" runat="server" ClientIDMode="Predictable"></asp:Literal>
                                    - Last Updated: <%# ShowTimeAgo(Eval("LastUpdateDate").ToString()) %></span>
                                <div class="ThreadUsers">
                                    <asp:Repeater ID="rptCharacters" runat="server">
                                        <ItemTemplate>
                                            <span data-toggle="tooltip" data-placement="bottom" class="<%# OnlineStatus(Eval("LastAction"), Eval("ShowWhenOnline")) %>" style="background-image: url(<%# DisplayImageString(Eval("DisplayImageURL").ToString(), "thumb") %>);" title="<%# Eval("CharacterDisplayName") %>"></span>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                            <div class="Options">
                                <ul>
                                    <%--<li class="Delete"><a href="#" title="Delete" data-toggle="tooltip" data-placement="left"><span class="glyphicon glyphicon-remove-circle"></span></a></li>--%>
                                    <li runat="server" id="liSelectThread" class="MarkUnread" clientidmode="Predictable">
                                        <asp:CheckBox ID="chkSelectThread" runat="server" CssClass="FancyCheck NoText" title="Select Thread" data-toggle="tooltip" data-placement="left" Text=" " /></li>
                                    <%--<li runat="server" id="liMarkUnread" class="MarkUnread" clientidmode="Predictable" visible="false">
                                        <asp:LinkButton ID="btnMarkUnread" ClientIDMode="Predictable" runat="server" title="Mark as Unread" data-toggle="tooltip" data-placement="left" CommandName="MarkUnread"><span class="glyphicon glyphicon-folder-close"></span></asp:LinkButton></li>
                                    <li runat="server" id="liMarkRead" class="MarkRead" clientidmode="Predictable" visible="false">
                                        <asp:LinkButton ID="btnMarkRead" ClientIDMode="Predictable" runat="server" title="Mark as Read" data-toggle="tooltip" data-placement="left" CommandName="MarkRead"><span class="glyphicon glyphicon-folder-open"></span></asp:LinkButton></li>--%>
                                </ul>
                            </div>
                        </asp:Panel>
                    </ItemTemplate>
                </asp:Repeater>
                <%--                <asp:SqlDataSource ID="sdsThreads" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT Thread_Users.UserID, Thread_Users.ReadStatusID, Thread_User_Read_Statuses.ReadStatus, Thread_User_Permissions.PermissionDescription, Thread_User_Permissions.ThreadUserPermissionID, ThreadsWithMostRecentUpdateDate.ThreadTitle, ThreadsWithMostRecentUpdateDate.ThreadID, ThreadsWithMostRecentUpdateDate.LastUpdateDate FROM Thread_Users INNER JOIN Thread_User_Read_Statuses ON Thread_Users.ReadStatusID = Thread_User_Read_Statuses.ReadStatusID INNER JOIN Thread_User_Permissions ON Thread_Users.PermissionID = Thread_User_Permissions.ThreadUserPermissionID INNER JOIN ThreadsWithMostRecentUpdateDate ON Thread_Users.ThreadID = ThreadsWithMostRecentUpdateDate.ThreadID WHERE (Thread_Users.DeletedDate IS NULL) AND (Thread_Users.UserID = @UserID) Order By LastUpdateDate DESC">
                    <SelectParameters>
                        <asp:SessionParameter Name="UserID" SessionField="UserID" />
                    </SelectParameters>
                </asp:SqlDataSource>--%>
                <asp:SqlDataSource ID="sdsCharacters" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT Characters.CharacterNameClass, Characters.CharacterID, Characters.CharacterDisplayName, Characters.DisplayImageURL, Thread_Users.ThreadID, Characters.LastAction, Characters.ShowWhenOnline FROM Thread_Users INNER JOIN CharactersWithDetails AS Characters ON Thread_Users.CharacterID = Characters.CharacterID WHERE (Thread_Users.ThreadID = @ThreadID)">
                    <SelectParameters>
                        <asp:Parameter Name="ThreadID" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </asp:Panel>
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
        </fieldset>
        <div class="ButtonPanel clearfix">
            <div class="col-xl-3 col-sm-4 col-xs-12">
                <asp:Button ID="btnDeleteSelectedThreads" runat="server" Text="Leave Selected Threads" CssClass="btn btn-danger" OnClick="btnDeleteSelectedThreads_Click" OnClientClick="deactivateButton(this);" />
            </div>
            <div class="col-xl-3 col-sm-4 col-xs-12">
            </div>
            <div class="col-xl-3 col-sm-4 col-xs-12">
            </div>
        </div>
    </ContentTemplate>
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="rptThreadListing" EventName="ItemCommand" />
        <asp:AsyncPostBackTrigger ControlID="btnMarkAsUnread" EventName="Click" />
    </Triggers>
</asp:UpdatePanel>
