<%@ Page Title="RPG: About Us" Language="C#" MasterPageFile="~/templates/1-Col.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.About_Us.Default" %>

<%@ Register Src="~/templates/controls/CharacterListing.ascx" TagPrefix="uc1" TagName="CharacterListing" %>


<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="RPG is an effort to create an environment (from scratch) and a community that will allow Role-Players to use tools made directly for our favorite hobby. RPG promises that all development will be pursued in the spirit of the betterment of user experience and the desires voiced by the community members." />
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="FullCol" runat="server">
    <h1>About the Role-Players Guild</h1>
    <h2>Mission</h2>
    <p>After 15+ years of RPing on various different medias, it became painfully obvious that there was no environment singularly targeted to Role-Players. Many of us RP in environments such as Chatrooms and MMORPG's, and though those environments are great, over time we have realized that we're just working around tools that happen to exist, yet aren't particularly made for us. RPG is an effort to create an environment (from scratch) and a community that will allow Role-Players to use tools made specifically for our favorite hobby. RPG promises that all development will be pursued in the spirit of the betterment of user experience and the desires voiced by the community members.</p>
    <h2>Development</h2>
    <p>RPG thrives off of community feedback. Because of this, RPG has a built in functionality voting system. Users can suggest new functionality and also vote for the ideas they like. This ensures that only the most desired features are worked on and the development isn't wasted on features that no one wants.</p>
    <h2>Support</h2>
    <p>If you would like to support RPG on other websites, please feel free to use any of these graphics below:</p>
    <p>
        <img src="/Images/Banners/Banner-1.png" style="width: 100%; max-width: 980px;" />
    </p>
    <pre>&lt;a href=&quot;http://www.roleplayersguild.com<asp:Literal ID="litBanner1" runat="server"></asp:Literal>&quot;&gt;&lt;img src=&quot;/Images/Banners/Banner-1.png&quot; style=&quot;width: 100%; max-width: 980px;&quot; /&gt;&lt;/a&gt;</pre>
    <p>
        <img src="/Images/Banners/Banner-2.gif" style="width: 100%; max-width: 980px;" />
    </p>
    <pre>&lt;a href=&quot;http://www.roleplayersguild.com<asp:Literal ID="litBanner2" runat="server"></asp:Literal>&quot;&gt;&lt;img src=&quot;/Images/Banners/Banner-2.gif&quot; style=&quot;width: 100%; max-width: 980px;&quot; /&gt;&lt;/a&gt;</pre>
    <p>
        <img src="/Images/Banners/Banner-3.jpg" style="width: 100%; max-width: 980px;" />
    </p>
    <pre>&lt;a href=&quot;http://www.roleplayersguild.com<asp:Literal ID="litBanner3" runat="server"></asp:Literal>&quot;&gt;&lt;img src=&quot;/Images/Banners/Banner-3.gif&quot; style=&quot;width: 100%; max-width: 980px;&quot; /&gt;&lt;/a&gt;</pre>
    <p>
        <img src="/Images/Banners/Banner-4.png" style="width: 100%; max-width: 980px;" />
    </p>
    <pre>&lt;a href=&quot;http://www.roleplayersguild.com<asp:Literal ID="litBanner4" runat="server"></asp:Literal>&quot;&gt;&lt;img src=&quot;/Images/Banners/Banner-2.gif&quot; style=&quot;width: 100%; max-width: 980px;&quot; /&gt;&lt;/a&gt;</pre>

    <p runat="server" id="pPlainURL" visible="false">Bellow is the plain URL for referral credit. Copy/pasting this into most chat clients or other websites should generally allow other users to easily navigate to RPG and automatically give you credit if they were sent by you.</p>
    <pre runat="server" id="prePlainURL" visible="false">http://www.roleplayersguild.com<asp:Literal ID="litPlainURL" runat="server"></asp:Literal></pre>

    <h3>Donations &amp; Memberships</h3>
    <p>Another way to show support for RPG is to send in donations or purchase a paid membership. If you are not logged in, you can make an anonymous donation. However, if you log in and make a donation, you will receive a Donation badge. Each of these badges allow you to change the color of the name of any one of your characters to green. Donations of $100 USD or higher receive Large Donation badges, allowing you to use a green name with a glow around it.</p>
    <input type="hidden" name="custom" value="<%= CurrentUserID() %>">
    <input type="hidden" name="cmd" value="_s-xclick">
    <input type="hidden" name="hosted_button_id" value="D4UR4R8SFH79C">
    <p>
        <asp:Button ID="btnDonate" runat="server" Text="Donate via PayPal" PostBackUrl="https://www.paypal.com/cgi-bin/webscr" CssClass="btn btn-primary" /></p>
    <p>Otherwise, you can log in to <a href="/Memberships/" target="_blank">learn more about purchasing a paid membership</a>.</p>

    <h2>Costs</h2>
    <p>Because this community is to be driven by the users, we would like to make sure everything is transparent, including our costs. At the moment, RPG has the following costs:</p>
    <ul>
        <li>Amazon DataTransfer Charges - $120/Month</li>        
        <li>Amazon RDS Charges - $70/Month</li>
        <li>Amazon EC2 Charges - $30/Month</li>
        <li>Amazon S3 Charges - $10/Month</li>        
    </ul>
    <p>Of course, there's also the time and effort put in by our staff. The staff is, however, working pro bono.</p>
    <h2>Staff</h2>
    <p>RPG is always looking for people who are interested in becoming official staff members. Skills with HTML/CSS are great. Understanding of ASP.NET, C#, SQL and IIS are a huge plus, but not required. If you are interested in joining the RPG Staff, please <a href="/Report/">send an application in via our reports system</a>.</p>

</asp:Content>
