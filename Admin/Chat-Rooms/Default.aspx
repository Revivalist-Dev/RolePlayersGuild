<%@ Page Title="Manage Chat Rooms on RPG" Language="C#" MasterPageFile="~/templates/2ColAdmin.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.Admin.ChatRooms.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphTop" runat="server">
    <p>
        <a href="../">&laquo;&nbsp;Back to Admin Console</a>
    </p>

    <div class="col-xs-3">
        <asp:ListBox ID="lbChatRooms" runat="server" Width="100%" Rows="45" DataSourceID="sdsChatRooms" DataTextField="ChatRoomName" DataValueField="ChatRoomID" AutoPostBack="True" OnSelectedIndexChanged="lbChatRooms_SelectedIndexChanged" OnDataBound="lbChatRooms_DataBound"></asp:ListBox>
        <asp:SqlDataSource ID="sdsChatRooms" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT [ChatRoomID], Case When [ChatRoomStatusID] = 1 Then '[PA] - ' + [ChatRoomName] else [ChatRoomName] End As ChatRoomName FROM [Chat_Rooms] ORDER BY [ChatRoomStatusID], [ChatRoomName]"></asp:SqlDataSource>
    </div>
    <div runat="server" id="divTools" class="col-xs-9">
        <asp:Panel ID="pnlMessage" runat="server" ViewStateMode="Disabled" Visible="false" role="alert">
            <asp:Literal ID="litMessage" runat="server" ViewStateMode="Disabled"></asp:Literal>
        </asp:Panel>
        <asp:HyperLink ID="lnkChatRoom" runat="server">Visit Chat Room &raquo;</asp:HyperLink>
        <%--<h1>
            <asp:Literal ID="litUniverseName" runat="server"></asp:Literal></h1>--%>
        <div>
            <div class="form-group">
                <label for="txtUniverseName">Chat Room Name</label>
                <asp:TextBox ID="txtChatRoom" runat="server" CssClass="form-control"></asp:TextBox>
            </div>

            <div class="form-group">
                <label for="txtDescription">Description</label>
                <asp:TextBox ID="txtDescription" runat="server" Width="100%" Rows="15" TextMode="MultiLine" CssClass="form-control" ValidateRequestMode="Disabled"></asp:TextBox>
            </div>


            <div class="form-group">
                <label for="ddlRating">Content Rating</label>
                <div class="input-group">
                    <asp:DropDownList ID="ddlRating" runat="server" CssClass="form-control">
                        <asp:ListItem Text="Teen" Value="1"></asp:ListItem>
                        <asp:ListItem Text="Mature" Value="2"></asp:ListItem>
                    </asp:DropDownList>
                    <span class="input-group-btn">
                        <a href="#" data-toggle="modal" data-target="#RatingDescription" class="btn btn-info" tabindex="-1"><span class="glyphicon glyphicon-question-sign"></span></a>
                    </span>
                </div>
            </div>
            <div class="form-group">
                <label for="ddlRating">Universe</label>
                <asp:DropDownList ID="ddlUniverses" runat="server" CssClass="form-control" AppendDataBoundItems="True" DataSourceID="sdsUniverses" DataTextField="UniverseName" DataValueField="UniverseID">
                    <asp:ListItem Text="OOC" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:SqlDataSource ID="sdsUniverses" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT [UniverseName], [UniverseID] FROM [Universes] WHERE ([UniverseID] &lt;&gt; @UniverseID) ORDER BY [UniverseName]">
                    <SelectParameters>
                        <asp:Parameter DefaultValue="29" Name="UniverseID" Type="Int32" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:HyperLink ID="lnkUniverse" runat="server">Visit Universe &raquo;</asp:HyperLink>
            </div>
            <div class="form-group">
                <asp:HyperLink ID="lnkSubmittedBy" runat="server">Submitter</asp:HyperLink>
            </div>
            <div class="checkbox FancyCheck">
                <asp:CheckBox ID="chkApproved" ClientIDMode="Static" runat="server" Text="Chat Room is approved." />
            </div>
            <div class="ButtonPanel clearfix">
                <div class="col-xl-3 col-sm-4 col-xs-12">
                    <asp:HyperLink ID="lnkDeleteChatRoom" runat="server" Text="Delete Chat Room" CssClass="btn btn-danger" data-toggle="modal" data-target="#DeleteChatRoomModal" />
                </div>
                <div class="col-xl-3 col-sm-4 col-xs-12">
                </div>
                <div class="col-xl-3 col-sm-4 col-xs-12 col-xl-offset-3">
                    <asp:Button ID="btnSaveChatRoom" runat="server" Text="Save Chat Room" CssClass="btn btn-success" OnClick="btnSaveChatRoom_Click" />
                </div>
            </div>
            <h2>User Locking</h2>
            <asp:Panel runat="server" ID="pnlLocking" Style="margin: 1em 0;" DefaultButton="btnLockUser">
                <div>
                    <asp:TextBox ID="txtUserIDToLock" runat="server" TextMode="Number" CssClass="form-control"></asp:TextBox>
                    <div class="ButtonPanel clearfix">
                        <div class="col-xl-3 col-sm-4 col-xs-12">
                        </div>
                        <div class="col-xl-3 col-sm-4 col-xs-12">
                        </div>
                        <div class="col-xl-3 col-sm-4 col-xs-12 col-xl-offset-3">
                            <asp:Button ID="btnLockUser" runat="server" Text="Lock User Out" CssClass="btn btn-danger" OnClick="btnLockUser_Click" />
                        </div>
                    </div>
                </div>
                <asp:Repeater ID="rptLockedUsers" runat="server" DataSourceID="sdsUsers" OnItemCommand="rptLockedUsers_ItemCommand">
                    <ItemTemplate>
                        <div class="clearfix" style="border-bottom: #666 1px solid; padding: 10px 0;">
                            <div class="col-sm-6" style="overflow: hidden;"><%# Eval("Username") %> </div>
                            <div class="col-sm-6" style="text-align: right;">
                                <a href='/Admin/Users?id=<%# Eval("UserID") %>' class="btn btn-primary">View User</a>
                                <asp:Button ID="btnUnlock" runat="server" Text="Unlock User" CssClass="btn btn-warning btn-sm" CommandName="UnlockUser" CommandArgument='<%# Eval("UserID") %>' />
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:SqlDataSource ID="sdsUsers" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT Users.UserID, (Cast(Users.UserID As NVARCHAR) + ' - ' + ISNULL(Users.Username, '')) As Username, Chat_Room_Locks.ChatRoomID FROM Users INNER JOIN Chat_Room_Locks ON Users.UserID = Chat_Room_Locks.UserID WHERE Chat_Room_Locks.ChatRoomID = @ChatRoomID">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="lbChatRooms" Name="ChatRoomID" PropertyName="SelectedValue" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </asp:Panel>
            <h2>Chat Purging</h2>
            <div class="ButtonPanel clearfix">
                <div class="col-xl-3 col-sm-4 col-xs-12">
                </div>
                <div class="col-xl-3 col-sm-4 col-xs-12">
                </div>
                <div class="col-xl-3 col-sm-4 col-xs-12">
                    <asp:Button ID="btnPurgeChatRoom" runat="server" Text="Purge Chat Room" CssClass="btn btn-danger" OnClick="btnPurgeChatRoom_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphLeftCol" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphRightCol" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="cphBottom" runat="server">
    <div class="modal fade" id="DeleteChatRoomModal" tabindex="-1" role="dialog" aria-labelledby="DeleteChatRoomLabel" runat="server" clientidmode="Static">
        <div class="modal-dialog" role="document">
            <div class="modal-content alert-danger">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="DeleteChatRoomLabel">Are you sure?</h4>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete this Chat Room?</p>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnDeleteChatRoom" runat="server" Text="Delete Chat Room" CssClass="btn btn-danger" OnClick="btnDeleteChatRoom_Click" />

                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="RatingDescription" tabindex="-1" role="dialog" aria-labelledby="RatingLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="RatingLabel">Content Ratings</h4>
                </div>
                <div class="modal-body">
                    <p>Content ratings can be defined as so:</p>
                    <ul>
                        <li><strong>Teen:</strong>
                            Content is generally suitable for ages 13 and up. May contain violence, suggestive themes, crude humor, minimal blood, simulated gambling and/or infrequent use of strong language.
                        </li>
                        <li><strong>Mature:</strong>
                            Content is generally suitable for ages 17 and up. May contain intense violence, blood and gore, sexual content and/or strong language.
                        </li>
                    </ul>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="cphScripts" runat="server">
</asp:Content>
