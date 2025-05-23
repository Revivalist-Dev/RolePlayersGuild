<%@ Page Title="" Language="C#" MasterPageFile="~/templates/2-Col.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.Register.Default" %>

<%@ MasterType VirtualPath="~/templates/2-Col.master" %>

<asp:Content ID="Content3" runat="server" ContentPlaceHolderID="cphTopRow">
    <asp:Panel ID="pnlMessage" runat="server" ViewStateMode="Disabled" Visible="false" role="alert">
        <asp:Literal ID="litMessage" runat="server" ViewStateMode="Disabled"></asp:Literal>
    </asp:Panel>

</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" runat="server">
    <div id="divAgreementText" runat="server" class="hidden-xs alert alert-info" style="max-height: 500px; overflow: auto; margin-bottom: 5px;">
        <h4>What am I agreeing to by registering?</h4>
        <p>By clicking on <strong>"Complete Registration"</strong> you are acknowledging that you understand that as you become aware of particular rules of this community, you will follow them. If rules change you are agreeing that you will follow the new rules without exception and that it is your responsibility to ensure that you are up to date on the rules as the community grows.</p>
        <p>Though mature content is allowed on this community, it must be kept to appropriately flagged content and in its proper place. If mature content is seen out of place, this may result in various actions, such as a deletion of the content with a warning or, a full account deletion without warning.</p>
        <p>Users of RPG understand that all content submitted or created is subject to review and if anything is in violation of local or federal law, it will be removed instantly and reported to officials. Likewise, users of RPG understand that any content can be removed or altered at any time by the RPG staff as seen necessary without warning.</p>
        <p>Users agree to allow RPG to store their email addresses in case of need to contact.</p>
        <p>RPG does not claim ownership to any material created by users on the website, RPG does, however claim the right to publicize the materials created by users without request of permission for use in marketing materials or documentation.</p>        
        <p>Users of RPG understand that the terms of service may change at any time and it is their responsibility to keep up with these terms to ensure that they are fully aware of the details included.</p>
    </div>
    
    <div class="modal fade" id="InfoModal" tabindex="-1" role="dialog" aria-labelledby="InfoLabel" runat="server" clientidmode="Static">
        <div class="modal-dialog" role="document">
            <div class="modal-content alert-info">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="InfoLabel">What is this?</h4>
                </div>
                <div id="divMoblFriendlyAgreementText" runat="server" class="modal-body" style="max-height: 300px; overflow: auto;">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphRightCol" runat="server">
    <h3>Register as a Member of RPG</h3>
    <asp:Panel ID="pnlRegistrationForm" runat="server">
        <div class="form-group">
            <label for="txtUsername">Username</label>
            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="This is your username, not a character name." required autofocus></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvUsername" SetFocusOnError="true" runat="server" ErrorMessage="You must enter a username." ControlToValidate="txtUsername" Display="Dynamic" CssClass="label label-danger"></asp:RequiredFieldValidator>
        </div>
        <div class="form-group">
            <label for="txtEmailAddress">Email Address</label>
            <asp:TextBox ID="txtEmailAddress" runat="server" TextMode="Email" CssClass="form-control" placeholder="Email Address" required></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvEmailAddress" SetFocusOnError="true" runat="server" ErrorMessage="You must enter an email address." ControlToValidate="txtEmailAddress" Display="Dynamic" CssClass="label label-danger"></asp:RequiredFieldValidator>
        </div>
        <div class="form-group">
            <label for="txtPassword">Password</label>
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Password" required></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvPassword" SetFocusOnError="true" runat="server" ErrorMessage="You must enter a password." ControlToValidate="txtPassword" Display="Dynamic" CssClass="label label-danger"></asp:RequiredFieldValidator>
        </div>
        <div class="form-group">
            <label for="txtPasswordConfirm">Confirm Password</label>
            <asp:TextBox ID="txtPasswordConfirm" runat="server" TextMode="Password" CssClass="form-control" placeholder="Password Again" required></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvPasswordConfirm" SetFocusOnError="true" runat="server" ErrorMessage="You must confirm your password." ControlToValidate="txtPasswordConfirm" Display="Dynamic" CssClass="label label-danger"></asp:RequiredFieldValidator>
            <asp:CompareValidator ID="covPasswordConfirm" SetFocusOnError="true" runat="server" ErrorMessage="Your passwords do not match." ControlToCompare="txtPassword" ControlToValidate="txtPasswordConfirm" Display="Dynamic" CssClass="label label-danger"></asp:CompareValidator>
        </div>
        <%--        <div class="form-group">
            <label for="txtSecretCode">Secret Code</label>
            <asp:TextBox ID="txtSecretCode" runat="server" TextMode="Password" CssClass="form-control" placeholder="DO IT NAO!" required></asp:TextBox>            
            <asp:RequiredFieldValidator ID="rfvSecretCode" runat="server" ErrorMessage="I said, do it." ControlToValidate="txtSecretCode" Display="Dynamic" CssClass="label label-danger"></asp:RequiredFieldValidator>
        </div>--%>
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
        <asp:HyperLink ID="lnkWhatAmIAgreeingTo" runat="server" CssClass="visible-xs btn btn-info" Style="margin-bottom: 5px;" data-toggle="modal" data-target="#InfoModal">What am I agreeing to by registering?</asp:HyperLink> 
        <asp:Button ID="btnRegister" runat="server" Text="Complete Registration" CssClass="btn btn-primary btn-block" OnClick="btnRegister_Click" />
    </asp:Panel>
</asp:Content>

