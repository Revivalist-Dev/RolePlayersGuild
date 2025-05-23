<%@ Page Title="Recover RPG Password" Language="C#" MasterPageFile="~/templates/1-Col.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.Account_Recovery.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Lost or forgot your password? Recover it here." />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FullCol" runat="server">
    <div class="container">
        <div id="divRecoveryPanel" runat="server" class="panel panel-primary" style="max-width: 700px; margin: 0 auto;">
            <div class="panel-heading">
                <h3 class="panel-title">Password Recovery</h3>
            </div>
            <div id="divMessage" runat="server" class="panel-body" visible="false">
                <asp:Literal ID="litMessage" runat="server"></asp:Literal>
            </div>
            <div id="divPanelBody" runat="server" class="panel-body">
                <p>To recover your password, simply enter your email address below. If your email address matches our records, you will receive an email with a link to reset your password. If there is no match, however, or you no longer have access to the email address used to create your account, you will have to <a href="/register/">make a new account</a> instead.</p>

                <div class="form-group">
                    <label for="txtEmailAddress">Email Address</label>
                    <asp:TextBox ID="txtEmailAddress" runat="server" TextMode="Email" CssClass="form-control" placeholder="password@iForgot.com" required autofocus></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvEmailAddress" SetFocusOnError="true" runat="server" ErrorMessage="You must enter an email address." ControlToValidate="txtEmailAddress" Display="Dynamic" CssClass="label label-danger"></asp:RequiredFieldValidator>
                </div>
                <style>
                    @media screen and (max-width: 375px) {
                        #rc-imageselect, .g-recaptcha {
                            transform: scale(0.77);
                            -webkit-transform: scale(0.77);
                            transform-origin: 0 0;
                            -webkit-transform-origin: 0 0;
                        }
                    }
                </style>
                <div class="form-group">
                    <div class="g-recaptcha" data-sitekey="6LdmzxkTAAAAAI48qzuw29CZ2KYaJ5XDzaN9pgBz"></div>
                </div>
                <asp:Button ID="btnRecoverPassword" runat="server" Text="Recover Password" CssClass="btn btn-primary" OnClick="btnRecoverPassword_Click" />
                <a href="/" class="btn btn-default">Cancel</a>
            </div>
        </div>
    </div>
</asp:Content>
