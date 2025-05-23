<%@ Page Title="Recover RPG Password" Language="C#" MasterPageFile="~/templates/1-Col.master" AutoEventWireup="true" CodeBehind="initiate.aspx.cs" Inherits="RolePlayersGuild.Account_Recovery.Initiate" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Lost or forgot your password? Recover it here." />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FullCol" runat="server">
    <div class="container">
        <div id="divRecoveryPanel" runat="server" class="panel panel-primary" style="max-width: 700px; margin: 0 auto;">
            <div class="panel-heading">
                <h3 class="panel-title">Password Recovery</h3>
            </div>
            <div id="divMessage" runat="server" class="panel-body">
                <asp:Literal ID="litMessage" runat="server"></asp:Literal>
            </div>
        </div>
    </div>
</asp:Content>
