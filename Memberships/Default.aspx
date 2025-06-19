<%@ Page Title="RPG: Memberships" Language="C#" MasterPageFile="~/templates/1-Col.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.Memberships.Default" %>

<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Show your support for RPG while also gaining access to exclusive features by purchasing a paid RPG membership." />
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="FullCol" runat="server">
    <h1>Role-Players Guild Paid Membership</h1>

    <p>Thank you for your interest in becoming a paid member of RPG. We couldn't have made it this far without the support of all of you.</p>
    <p>Your continued support is deeply appreciated and since we've put an official code freeze on RPG, it's time to move on to RPG2. The new system will be written on a much more scalable infrastructure and be able to support our growth and expansion without a problem. We'll also be able to offer much more refined features to our users!</p>
    <p>To celebrate the end of RPG1, we've made a change to the logic of our membership system. Now, if you buy a $5/mo membership, you can cancel it at any time after the initial payment and continue to reap the benefits of a paid membership without having to renew every month. No ads, unlimited images, and even a chance to get a secret badge if the whole community raises $5,000.</p>
    <p>Once you have your membership activated, you can cancel it by going to PayPal and simply telling PayPal to cancel any further payments. Again; this will not get in the way of anything you already have. If you'd like to help RPG reach the $5,000 goal, however, you can also keep the membership active! Members with paid memberships active from September 2017 until the launch of RPG2 will receive another RPG2 exclusive badge!</p>
    <p>So, to recap, here is what you get if you buy a Premium Membership:</p>
    <ul>
        <li>No Ads</li>
        <li>Unlimited Image Slots for Account</li>
        <li>Platinum Member Badge (Blue Name w/ Blue Glow)</li>
        <li>Unlimited Images Badge (White Name w/ Blue Glow)</li>
        <li>Secret Badge If $5,000 Funding Goal Is Reached</li>
        <li>Secret RPG2 Badge If Membership Active From September 2017 To Launch of RPG</li>
    </ul>
    
    <p>Users with the old Bronze/Silver/Gold memberships will be able to participate in this by canceling their current memberships and purchasing this one.</p>

    <div style="margin-top: 30px;">
        <input type="hidden" name="custom" value="<%= CurrentUserID() %>">
        <input type="hidden" name="cmd" value="_s-xclick">
        <input type="hidden" name="hosted_button_id" value="LDHSVWYTNK8FJ">
        <label>
            <input type="hidden" name="on0" value="Membership Level">Select Membership Level
        </label>
        <p>
            <select name="os0" class="form-control">
                <option value="Platinum Member">Premium Member : $5.00 USD - monthly</option>
            </select>
        </p>
        <input type="hidden" name="currency_code" value="USD">
        <p style="text-align: right;">
            <asp:Button ID="btnSubscribe" runat="server" Text="Start My Premium Membership Today" CssClass="btn btn-primary" PostBackUrl="https://www.paypal.com/cgi-bin/webscr" />
        </p>
        <p style="font-size: small; text-align: right;">Please Note: Membership purchases are non-refundable.</p>
    </div>
</asp:Content>
