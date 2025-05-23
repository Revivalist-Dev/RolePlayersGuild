<%@ Page Title="Manage Characters on RPG" Language="C#" MasterPageFile="~/templates/2ColAdmin.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.Admin.CharactersUnderReview.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphTop" runat="server">
    <p>
        <a href="../">&laquo;&nbsp;Back to Admin Console</a>
    </p>

    <div class="col-xs-3">
        <asp:ListBox ID="lbCharacters" runat="server" Width="100%" Rows="45" DataSourceID="sdsCharacters" DataTextField="CharacterName" DataValueField="CharacterID" AutoPostBack="true" OnSelectedIndexChanged="lbCharacters_SelectedIndexChanged"></asp:ListBox>
        <asp:SqlDataSource ID="sdsCharacters" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT [CharacterID], (Cast([CharacterID] As NVARCHAR) + ' - ' + [CharacterDisplayName]) As CharacterName FROM [Characters] Where CharacterStatusID = 2 ORDER BY [CharacterID]"></asp:SqlDataSource>
    </div>
    <div runat="server" id="divTools" class="col-xs-9">
        <asp:Panel ID="pnlMessage" runat="server" ViewStateMode="Disabled" Visible="false" role="alert">
            <asp:Literal ID="litMessage" runat="server" ViewStateMode="Disabled"></asp:Literal>
        </asp:Panel>
        <h1>
            <asp:Literal ID="litCharacterName" runat="server"></asp:Literal></h1>

        <div>
            <asp:HyperLink ID="lnkJumpToUser" runat="server" CssClass="btn btn-primary">Jump To User</asp:HyperLink>
        </div>
        <div style="margin-top:1em;">
            <asp:Button ID="btnUnlockCharacter" runat="server" Text="Unlock Character" CssClass="btn btn-primary" OnClick="btnUnlockCharacter_Click" />
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphLeftCol" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphRightCol" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="cphBottom" runat="server">
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="cphScripts" runat="server">
</asp:Content>
