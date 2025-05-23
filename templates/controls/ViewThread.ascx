<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ViewThread.ascx.cs" Inherits="RolePlayersGuild.templates.controls.ViewThread" %>
<%@ Register Src="~/templates/controls/EditThread.ascx" TagPrefix="uc1" TagName="EditThread" %>

<asp:Panel ID="pnlMessage" runat="server" ViewStateMode="Disabled" Visible="false" role="alert">
    <asp:Literal ID="litMessage" runat="server" ViewStateMode="Disabled"></asp:Literal>
</asp:Panel>

<asp:Panel runat="server" ID="pnlThreadInfo" class="ThreadInfo">
    <div class="ThreadUsers">
        <h1>
            <asp:Literal ID="litThreadTitle" runat="server"></asp:Literal></h1>
        <p>
            Last Update:
            <asp:Literal ID="litLastUpdate" runat="server"></asp:Literal>
        </p>

    </div>
</asp:Panel>
<div class="ButtonPanel clearfix">
    <div class="col-xl-3 col-sm-4 col-xs-12">
        <a runat="server" id="aViewEditCharacters" href="#" class="btn btn-primary" data-toggle="modal" data-target="#ViewEditUsersModal">View/Edit Characters</a>
    </div>
    <div class="col-xl-3 col-sm-4 col-xs-12">
    </div>
    <div class="col-xl-3 col-sm-4 col-xs-12 col-xl-offset-3">
        <asp:Button ID="btnMarkUnread" runat="server" Text="Mark Unread" CssClass="btn btn-warning" OnClick="btnMarkUnread_Click" />
        <%--<asp:HyperLink ID="lnkChangeOwner" runat="server" Text="Change Thread Owner" CssClass="btn btn-primary" data-toggle="modal" data-target="#ChangeOwnerModal" Visible="false" />--%>
    </div>
</div>
    <uc1:EditThread runat="server" ID="EditThread" ScreenStatus="AddPost" />

<asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
        <asp:Panel runat="server" ID="pnlFullThread" CssClass="FullThread">
            <asp:Repeater ID="rptMessages" runat="server" OnItemDataBound="rptMessages_ItemDataBound">
                <ItemTemplate>
                    <div class="ThreadMessage">
                        <div class="MessageInfo">
                            <ul>
                                <li class="UserName"><a href="/Character?id=<%#Eval("CharacterID") %>" class="<%# Eval("CharacterNameClass") %>"><%#Eval("CharacterDisplayName") %></a></li>
                                <li runat="server" id="liUserImage" clientidmode="Predictable" class="UserImage"><a href="/Character?id=<%#Eval("CharacterID") %>">
                                    <img src="<%# DisplayImageString(Eval("DisplayImageURL").ToString(), "thumb") %>" /></a></li>
                                <li runat="server" id="liUserOnline" class="UserOnline" visible="false">
                                    Online</li>
                                <li runat="server" id="liEditMessage"><a href="/My-Threads/Edit-Thread/?Mode=EditPost&ThreadID=<%#Eval("ThreadID") %>&mid=<%#Eval("ThreadMessageID") %>">Edit Message</a></li>
                                <%--<li runat="server" id="liBlockUser"><a href="#">Block User</a></li>--%>
                            </ul>
                        </div>
                        <div class="MessageContent">
                            <p class="small" style="padding: 0; margin: 0 0 5px 0;"><small>Posted: <%#ShowTimeAgo(Eval("MessageDate").ToString())%></small></p>
                            <span data-linkify><%# Eval("MessageContent").ToString() %></span>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
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
    </ContentTemplate>
</asp:UpdatePanel>
<div class="ButtonPanel clearfix">
    <div class="col-xl-3 col-sm-4 col-xs-12">
        <asp:HyperLink ID="lnkLeaveThread" runat="server" Text="Remove My Characters" CssClass="btn btn-danger" data-toggle="modal" data-target="#LeaveThreadModal" />
        <%--<asp:HyperLink ID="lnkDeleteThread" runat="server" Text="Delete Thread" CssClass="btn btn-danger" Visible="false" data-toggle="modal" data-target="#DeleteThreadModal" />--%>
    </div>
    <div class="col-xl-3 col-sm-4 col-xs-12">
    </div>
    <div class="col-xl-3 col-sm-4 col-xs-12">
    </div>
</div>
<%--<asp:SqlDataSource ID="sdsThreadMessages" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT Thread_Messages.ThreadMessageID, Thread_Messages.ThreadID, Characters.CharacterDisplayName, Thread_Messages.MessageContent, Thread_Messages.MessageDate, Characters.CharacterID, Characters.DisplayImageURL FROM Thread_Messages INNER JOIN CharactersWithDisplayImages As Characters ON Thread_Messages.CreatorID = Characters.CharacterID WHERE (Thread_Messages.ThreadID = @ThreadID) ORDER BY Thread_Messages.MessageDate">
    <SelectParameters>
        <asp:QueryStringParameter Name="ThreadID" QueryStringField="ThreadID" />
    </SelectParameters>
</asp:SqlDataSource>--%>

<asp:SqlDataSource ID="sdsCharacters" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT Characters.CharacterID, CASE WHEN Characters.ShowWhenOnline = 1 AND Characters.LastAction > DateAdd(hour, -3, GetDate()) THEN Characters.CharacterDisplayName + ' - <span class=''UserOnline inline''>Online</span>' ELSE CharacterDisplayName END As CharacterDisplayName, Thread_Users.ThreadID FROM Thread_Users INNER JOIN CharactersWithDetails AS Characters ON Thread_Users.CharacterID = Characters.CharacterID WHERE (Thread_Users.ThreadID = @ThreadID)">
    <SelectParameters>
        <asp:QueryStringParameter Name="ThreadID" QueryStringField="ThreadID" />
    </SelectParameters>
</asp:SqlDataSource>
<asp:SqlDataSource ID="sdsMyCharacters" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT Characters.CharacterID, Characters.CharacterDisplayName, Thread_Users.ThreadID FROM Thread_Users INNER JOIN Characters ON Thread_Users.CharacterID = Characters.CharacterID WHERE (Thread_Users.ThreadID = @ThreadID) AND (Characters.UserID = @UserID)">
    <SelectParameters>
        <asp:SessionParameter Name="UserID" SessionField="UserID" />
        <asp:QueryStringParameter Name="ThreadID" QueryStringField="ThreadID" />
    </SelectParameters>
</asp:SqlDataSource>
<div class="modal fade" id="ViewEditUsersModal" tabindex="-1" role="dialog" aria-labelledby="ViewEditUsersLabel">
    <div class="modal-dialog" role="document">
        <asp:UpdatePanel ID="UpdatePanel2" runat="server">
            <ContentTemplate>

                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title" id="ViewEditUsersLabel">Current Thread Users</h4>
                    </div>
                    <div class="modal-body">
                        <p>Below are the users currently associated with this thread:</p>
                        <%--<asp:Panel ID="pnlThreadCreatorMessage" runat="server" CssClass="alert alert-warning" Visible="false">As the creator of the thread, you can remove any character from this thread except for the one you used to create it.</asp:Panel>
                        <asp:Panel ID="pnlRemoveableCharacters" runat="server" class="SelectableCharacterList RemovableCharacters" Visible="false">
                            <asp:CheckBoxList ID="cblRemoveableCharacters" runat="server" RepeatLayout="UnorderedList" DataSourceID="sdsCharacters" DataValueField="CharacterID" DataTextField="CharacterDisplayName" OnDataBound="cblRemoveableCharacters_DataBound">
                            </asp:CheckBoxList>
                        </asp:Panel>--%>
                        <asp:Panel runat="server" ID="pnlOtherCharacters" CssClass="TextCharacterList">
                            <asp:Repeater ID="rptOtherCharacters" runat="server" DataSourceID="sdsCharacters">
                                <ItemTemplate>
                                    <div class="Character"><span class="DisplayName"><%# Eval("CharacterDisplayName") %></span></div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </asp:Panel>
                        <%--<div runat="server" id="divLookingToAddMessage" class="alert alert-info">Looking to add a new character to the thread? That feature is available to the creator of the thread! Ask the creator to add the character you want here.</div>--%>
                        <asp:Panel runat="server" ID="pnlUserSearch" DefaultButton="btnUserSearch_ViewThread" Visible="false">
                            <p>You can also add more characters to the thread here:</p>
                            <div class="form-inline">
                                <div class="form-group">
                                    <label class="sr-only" for="txtUserSearch">Search For Characters</label>
                                    <asp:TextBox ID="txtUserSearch" runat="server" CssClass="form-control" placeholder="Type your search here." ValidationGroup="UserSearch"></asp:TextBox>
                                </div>
                                <asp:Button ID="btnUserSearch_ViewThread" runat="server" Text="Find Characters" CssClass="btn btn-default" OnClick="btnUserSearch_ViewThread_Click" ValidationGroup="UserSearch" />
                            </div>
                            <asp:RequiredFieldValidator ID="rfvUserSearch" runat="server" ErrorMessage="You must enter something to search for." ControlToValidate="txtUserSearch" Display="Dynamic" SetFocusOnError="true" CssClass="label label-danger" ValidationGroup="UserSearch"></asp:RequiredFieldValidator>
                            <script type="text/javascript">
                                Sys.Application.add_load(BindEvents);
                                function BindEvents() {
                                    $('[data-toggle=tooltip]').tooltip();
                                }
                            </script>
                            <asp:Panel ID="pnlSearchResults" runat="server" class="SelectableCharacterList UserSearchResults" Visible="false">
                                <asp:CheckBoxList ID="cblUserSearchResults" runat="server" RepeatLayout="UnorderedList">
                                </asp:CheckBoxList>
                            </asp:Panel>

                            <asp:Panel ID="pnlSearchMessage" runat="server" CssClass="alert alert-info" Visible="false">
                                <asp:Literal ID="litSearchMessage" runat="server"></asp:Literal>
                            </asp:Panel>
                        </asp:Panel>
                    </div>
                    <div class="modal-footer">
                        <asp:Button ID="btnSaveCharacterSelection" runat="server" Text="Save Changes" Visible="false" CssClass="btn btn-primary" OnClientClick="Closepopup(); return true;" ValidationGroup="SelectUsers" OnClick="btnSaveCharacterSelection_Click" />

                        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                    </div>
                </div>
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="btnUserSearch_ViewThread" />
            </Triggers>
        </asp:UpdatePanel>
    </div>
</div>
<%--<div class="modal fade" id="DeleteThreadModal" tabindex="-1" role="dialog" aria-labelledby="DeleteThreadLabel" runat="server" clientidmode="Static">
    <div class="modal-dialog" role="document">
        <div class="modal-content alert-danger">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="DeleteThreadLabel">Are you sure?</h4>
            </div>
            <div class="modal-body">
                <p>Deleting this thread will make it unavailable for any Writer previously associated to it. This is permanent and once a thread is deleted, it cannot be recovered.</p>
                <p>Please keep in mind that we are planning to eventually release a feature that will allow you to download and save print-friendly versions of your Role-Plays.</p>
                <p>Are you certain you wish to delete this forever?</p>
            </div>
            <div class="modal-footer">
                <asp:Button ID="btnDeleteThread" runat="server" Text="Delete Thread" CssClass="btn btn-danger" OnClick="btnDeleteThread_Click" />

                <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
            </div>
        </div>
    </div>
</div>--%>
<div class="modal fade" id="LeaveThreadModal" tabindex="-1" role="dialog" aria-labelledby="LeaveThreadLabel" runat="server" clientidmode="Static">
    <div class="modal-dialog" role="document">
        <div class="modal-content alert-danger">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="LeaveThreadLabel">Are you sure?</h4>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to leave this thread? You will no longer be able to see posts on this thread unless the creator adds you back to it.</p>
                <asp:Panel ID="pnlMyCharacters" runat="server" class="SelectableCharacterList RemovableCharacters">
                    <asp:CheckBoxList ID="cblMyCharacters" runat="server" RepeatLayout="UnorderedList" DataSourceID="sdsMyCharacters" DataValueField="CharacterID" DataTextField="CharacterDisplayName">
                    </asp:CheckBoxList>
                </asp:Panel>
            </div>
            <div class="modal-footer">
                <asp:Button ID="btnLeaveThread" runat="server" Text="Remove Characters" CssClass="btn btn-danger" OnClick="btnLeaveThread_Click" />

                <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
            </div>
        </div>
    </div>
</div>
<%--<div class="modal fade" id="ChangeOwnerModal" tabindex="-1" role="dialog" aria-labelledby="ChangeOwnerLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="ChangeOwnerLabel">Current Thread Users</h4>
            </div>
            <div class="modal-body">
                <p>Below are the users currently associated with this thread:</p>
                <asp:Panel ID="pnlOwnerCapableCharacters" runat="server" class="SelectableCharacterList">
                    <asp:RadioButtonList ID="rblOwnerCapableCharacters" runat="server" RepeatLayout="UnorderedList" DataSourceID="sdsCharacters" DataValueField="CharacterID" DataTextField="CharacterDisplayName" OnDataBound="rblOwnerCapableCharacters_DataBound">
                    </asp:RadioButtonList>
                </asp:Panel>
            </div>
            <div class="modal-footer">
                <asp:Button ID="btnSaveNewOwner" runat="server" Text="Assign New Owner" CssClass="btn btn-primary" OnClientClick="Closepopup(); return true;" OnClick="btnSaveNewOwner_Click" />

                <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
            </div>
        </div>
    </div>
</div>--%>
