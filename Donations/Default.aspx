<%@ Page Title="RPG: Donations" Language="C#" MasterPageFile="~/templates/1-Col.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.Donations.Default" %>

<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Show your support for RPG by donating and acquiring a Donation badge." />
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="FullCol" runat="server">
    <h1>Donate to the Role-Players Guild</h1>

    <p>One way to show support for RPG is to send in donations. If you are not logged in, you can make an anonymous donation. Otherwise, if you log in and make a donation, you will receive a Donation badge. Each of these badges allow you to change the color of the name of any one of your characters to green. Donations of $100 USD or higher receive Large Donation badges, allowing you to use a green name with a glow around it.</p>
    <input type="hidden" name="custom" value="<%= CurrentUserID() %>">
    <input type="hidden" name="cmd" value="_s-xclick">
    <input type="hidden" name="hosted_button_id" value="D4UR4R8SFH79C">
    <p>
        <asp:Button ID="btnDonate" runat="server" Text="Donate via PayPal" PostBackUrl="https://www.paypal.com/cgi-bin/webscr" CssClass="btn btn-primary" />
    </p>
</asp:Content>
