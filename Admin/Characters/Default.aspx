<%@ Page Title="Manage Characters on RPG" Language="C#" MasterPageFile="~/templates/2ColAdmin.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.Admin.Characters.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphTop" runat="server">
    <p>
        <a href="../">&laquo;&nbsp;Back to Admin Console</a>
    </p>

    <div class="col-xs-3">
        <%-- <asp:ListBox ID="lbCharacters" runat="server" Width="100%" Rows="45" DataSourceID="sdsCharacters" DataTextField="CharacterName" DataValueField="CharacterID" AutoPostBack="true" OnSelectedIndexChanged="lbCharacters_SelectedIndexChanged"></asp:ListBox>
        <asp:SqlDataSource ID="sdsCharacters" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT [CharacterID], (Cast([CharacterID] As NVARCHAR) + ' - ' + [CharacterDisplayName]) As CharacterName FROM [Characters] ORDER BY [CharacterID]"></asp:SqlDataSource>--%>

        <div class="form-group">
            <asp:TextBox ID="txtCharacterID" runat="server" CssClass="form-control" ClientIDMode="Static" placeholder="Character ID" MaxLength="50"></asp:TextBox>
            <br />
            <asp:Button ID="btnSearch" runat="server" Text="Get Character" CssClass="btn btn-primary btn-block btn-sm" OnClick="btnSearch_Click" />

        </div>
    </div>
    <div class="col-xs-9">
        <asp:Panel ID="pnlMessage" runat="server" ViewStateMode="Disabled" Visible="false" role="alert">
            <asp:Literal ID="litMessage" runat="server" ViewStateMode="Disabled"></asp:Literal>
        </asp:Panel>
        <div runat="server" id="divTools" class="col-xs-9">
            <h1>
                <asp:Literal ID="litCharacterName" runat="server"></asp:Literal></h1>
            <div class="ButtonPanel clearfix">
                <div class="col-xl-3 col-sm-4 col-xs-12">
                    <a class="btn btn-primary" href="/Character?id=<%= ViewState["SelectedCharacterID"].ToString() %>" target="_blank">View Profile</a>
                </div>
                <div class="col-xl-3 col-sm-4 col-xs-12">
                    <a class="btn btn-primary" href="/My-Threads/Edit-Thread?Mode=NewThread&ToCharacters=<%= ViewState["SelectedCharacterID"].ToString() %>" target="_blank">Send Message</a>
                </div>
                <div class="col-xl-3 col-sm-4 col-xs-12">
                    <a class="btn btn-danger" href="#" data-toggle="modal" data-target="#DeleteCharacter">Delete Character</a>
                </div>
                <div class="col-xl-3 col-sm-4 col-xs-12">
                    <asp:HyperLink ID="lnkJumpToUser" runat="server" CssClass="btn btn-primary">Jump To User</asp:HyperLink>
                </div>
                <div class="col-xl-3 col-sm-4 col-xs-12">
                    <asp:HyperLink runat="server" ID="lnkMarkForReview" href="#" class="btn btn-danger" data-toggle="modal" data-target="#ReviewConfirmation">Mark For Review</asp:HyperLink>
                </div>
            </div>
            <div class="form-group">
                <label for="ddlType">Profile Type</label>
                <asp:DropDownList ID="ddlType" runat="server" CssClass="form-control" DataSourceID="sdsTypes" DataTextField="TypeName" DataValueField="TypeID">
                </asp:DropDownList>
                <asp:SqlDataSource ID="sdsTypes" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT * FROM [Character_Types] ORDER BY [TypeName]"></asp:SqlDataSource>
            </div>
            <div class="ButtonPanel clearfix">
                <div class="col-xl-3 col-sm-4 col-xs-12">
                </div>
                <div class="col-xl-3 col-sm-4 col-xs-12">
                </div>
                <div class="col-xl-3 col-sm-4 col-xs-12 col-xl-offset-3">
                    <asp:Button ID="btnSaveChanges" runat="server" Text="Save Changes" CssClass="btn btn-success" OnClick="btnSaveChanges_Click" />
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
    <div class="modal fade" id="DeleteCharacter" tabindex="-1" role="dialog" aria-labelledby="DeleteCharacterLabel" runat="server" clientidmode="Static">
        <div class="modal-dialog" role="document">
            <div class="modal-content alert-danger">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="DeleteCharacterLabel">Are you sure?</h4>
                </div>
                <div class="modal-body">
                    <p>This will delete the current character. Please only do this if you are certain this user is violating the rules of the website.</p>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnDeleteCharacter" runat="server" CssClass="btn btn-danger" Text="Delete Character" OnClick="btnDeleteCharacter_Click" />
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
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
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="cphScripts" runat="server">
</asp:Content>
