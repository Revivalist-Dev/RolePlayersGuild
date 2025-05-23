<%@ Page Title="Manage Users on RPG" Language="C#" MasterPageFile="~/templates/2ColAdmin.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.Admin.Users.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphTop" runat="server">
    <p>
        <a href="../">&laquo;&nbsp;Back to Admin Console</a>
    </p>

    <div class="col-xs-3">
        <asp:ListBox ID="lbUsers" runat="server" Width="100%" Rows="45" DataSourceID="sdsUsers" DataTextField="Username" DataValueField="UserID" AutoPostBack="True" OnSelectedIndexChanged="lbUsers_SelectedIndexChanged" OnDataBound="lbUsers_DataBound"></asp:ListBox>
        <asp:SqlDataSource ID="sdsUsers" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT [UserID], (Cast([UserID] As NVARCHAR) + ' - ' + ISNULL([Username], '')) As Username FROM [Users] ORDER BY [UserID]"></asp:SqlDataSource>
    </div>
    <div runat="server" id="divTools" class="col-xs-9">
        <asp:Panel ID="pnlMessage" runat="server" ViewStateMode="Disabled" Visible="false" role="alert">
            <asp:Literal ID="litMessage" runat="server" ViewStateMode="Disabled"></asp:Literal>
        </asp:Panel>
        <a class="btn btn-warning" href="#" data-toggle="modal" data-target="#BanUser" runat="server" id="aBanUser">Ban User</a>

        <h1>
            <asp:Literal ID="litUserName" runat="server"></asp:Literal></h1>
        <%-- <ul>
            <li>
                    <asp:Button ID="btnUnlockStream" runat="server" CssClass="btn btn-success" Text="Unock Stream" OnClick="btnUnlockStream_Click" Visible="false" />
                <asp:HyperLink ID="lnkLockStream" CssClass="btn btn-danger" data-toggle="modal" data-target="#LockStream" runat="server">Lock Stream</asp:HyperLink>
            </li>
        </ul>--%>

        <div class="form-group" runat="server" id="divUserType" visible="false">
            <label for="ddlSource">User Type</label>
            <div class="input-group">
                <asp:DropDownList ID="ddlUserType" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlUserType_SelectedIndexChanged">
                    <asp:ListItem Text="Basic" Value="1"></asp:ListItem>
                    <asp:ListItem Text="Lieutenant Moderator" Value="4"></asp:ListItem>
                    <asp:ListItem Text="Moderator" Value="2"></asp:ListItem>
                    <asp:ListItem Text="Admin" Value="3"></asp:ListItem>
                    <asp:ListItem Text="Trial Staff" Value="6"></asp:ListItem>
                </asp:DropDownList>
            </div>
        </div>
        <ul>
            <asp:Repeater ID="Repeater1" runat="server" DataSourceID="sdsCharacters">
                <ItemTemplate>
                    <li>
                        <a href="/Admin/Characters?id=<%# Eval("CharacterID").ToString() %>"><%# Eval("CharacterDisplayName").ToString() %> &raquo;</a>
                    </li>
                </ItemTemplate>
            </asp:Repeater>
        </ul>
        <asp:SqlDataSource ID="sdsCharacters" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT [CharacterID], [CharacterDisplayName] FROM [Characters] WHERE ([UserID] = @UserID)">
            <SelectParameters>
                <asp:ControlParameter ControlID="lbUsers" Name="UserID" PropertyName="SelectedValue" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>

        <h2>User Badges</h2>
        <div>
            <div class="ButtonPanel clearfix">
                <div class="col-xl-3 col-sm-4 col-xs-12">
                    <a class="btn btn-success" href="#" data-toggle="modal" data-target="#NewBadge">Award New Badge</a>
                </div>
                <div class="col-xl-3 col-sm-4 col-xs-12">
                </div>
                <div class="col-xl-3 col-sm-4 col-xs-12">
                </div>
            </div>
        </div>
        <div>
            <asp:Repeater ID="rptUserBadges" runat="server" DataSourceID="sdsUserBadges" OnItemCommand="rptUserBadges_ItemCommand">
                <ItemTemplate>
                    <div class="clearfix" style="border-bottom: #666 1px solid; padding: 10px 0;">
                        <div class="col-sm-6" style="overflow: hidden;">
                            <img class="UserBadge" src='<%# Eval("BadgeImageURL") %>' />
                            <%# Eval("BadgeName") %>
                        </div>
                        <div class="col-sm-6" style="text-align: right;">
                            <asp:Button ID="btnRemoveBadge" runat="server" Text="Remove Badge" CssClass="btn btn-danger btn-sm" CommandName="RemoveBadge" CommandArgument='<%# Eval("UserBadgeID") %>' />
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <asp:SqlDataSource ID="sdsUserBadges" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT Badges.BadgeName, Badges.BadgeImageURL, User_Badges.UserBadgeID FROM Badges INNER JOIN User_Badges ON Badges.BadgeID = User_Badges.BadgeID WHERE (User_Badges.UserID = @ParamOne)">
                <SelectParameters>
                    <asp:ControlParameter ControlID="lbUsers" Name="ParamOne" PropertyName="SelectedValue" />
                </SelectParameters>
            </asp:SqlDataSource>
        </div>
        <h2>User Notes</h2>
        <div>
            <div class="ButtonPanel clearfix">
                <div class="col-xl-3 col-sm-4 col-xs-12">
                    <a class="btn btn-success" href="#" data-toggle="modal" data-target="#NewNote">New Note</a>
                </div>
                <div class="col-xl-3 col-sm-4 col-xs-12">
                </div>
                <div class="col-xl-3 col-sm-4 col-xs-12">
                </div>
            </div>
        </div>
        <div>
            <asp:Repeater ID="rptUserNotes" runat="server" DataSourceID="sdsUserNotes">
                <ItemTemplate>
                    <div class="clearfix" style="border-bottom: #666 1px solid; padding: 10px 0;">
                        <div class="col-sm-12" style="overflow: hidden;" data-linkify>
                            <strong>By <%#Eval("CreatedByUserName") %></strong> - <%#Eval("TimeStamp") %> Pacific
                            <p><%#Eval("NoteContent") %></p>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <asp:SqlDataSource ID="sdsUserNotes" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="Select * From UserNotesWithDetails Where UserID = @ParamOne">
                <SelectParameters>
                    <asp:ControlParameter ControlID="lbUsers" Name="ParamOne" PropertyName="SelectedValue" />
                </SelectParameters>
            </asp:SqlDataSource>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphLeftCol" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphRightCol" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="cphBottom" runat="server">

    <div class="modal fade" id="BanUser" tabindex="-1" role="dialog" aria-labelledby="BanUserLabel" runat="server" clientidmode="Static">
        <div class="modal-dialog" role="document">
            <div class="modal-content alert-danger">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="BanUserLabel">Are you sure?</h4>
                </div>
                <div class="modal-body">
                    <p>This will completely delete this user!</p>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnBanUser" runat="server" Text="Ban User" Visible="false" CssClass="btn btn-warning" OnClick="btnBanUser_Click" />
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="NewBadge" tabindex="-1" role="dialog" aria-labelledby="NewBadgeLabel" runat="server" clientidmode="Static">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="NewBadgeLabel">Select a Badge</h4>
                </div>
                <div class="modal-body">
                    <asp:TextBox ID="txtBadgeReason" runat="server"></asp:TextBox>
                    <asp:RadioButtonList ID="rblBadges" runat="server" DataSourceID="sdsBadges" DataTextField="BadgeName" DataValueField="BadgeID"></asp:RadioButtonList>
                    <asp:SqlDataSource ID="sdsBadges" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT [BadgeID], [BadgeName] FROM [Badges] ORDER BY [BadgeName]"></asp:SqlDataSource>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnNewBadge" runat="server" Text="Award Badge" CssClass="btn btn-success" OnClick="btnNewBadge_Click" />
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="NewNote" tabindex="-1" role="dialog" aria-labelledby="NewBadgeLabel" runat="server" clientidmode="Static">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="NewNoteLabel">Add Note</h4>
                </div>
                <div class="modal-body">
                    <asp:TextBox ID="txtNote" runat="server" TextMode="MultiLine" Rows="10" Width="100%" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnNewNote" runat="server" Text="Add Note" CssClass="btn btn-success" OnClick="btnNewNote_Click" />
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="cphScripts" runat="server">
</asp:Content>
