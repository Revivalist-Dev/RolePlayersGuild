<%@ Page Title="RPG: FAQ" Language="C#" MasterPageFile="~/templates/1-Col.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.FAQ.Default" %>

<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="This website is built to easily and effectively allow us to pursue our hobby. Because of that, we try to make sure nothing is hard to find or do. In spirit of that, this page has answers to questions we hear most often." />
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="FullCol" runat="server">
    <h1>Frequently Asked Questions</h1>

    <div class="rpgAccordion panel-group" id="accordion">

        <div class="panel panel-default">
            <div class="panel-heading">
                <h4 class="panel-title">
                    <a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapseOne">Is account registration required?</a>
                </h4>
            </div>
            <div id="collapseOne" class="panel-collapse collapse">
                <div class="panel-body">
                    To view general content on the website, registration is not required. However, in order to view anything that is flagged as "Mature Content" you must be a member of the website.
                </div>
            </div>
        </div>
        <div class="panel panel-default">
            <div class="panel-heading">
                <h4 class="panel-title">
                    <a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapseTen">Do I have to make a character?</a>
                </h4>
            </div>
            <div id="collapseTen" class="panel-collapse collapse">
                <div class="panel-body">
                    If you want to message other users or upload images, yes, you have to create at least one character.
                </div>
            </div>
        </div>
         <div class="panel panel-default">
            <div class="panel-heading">
                <h4 class="panel-title">
                    <a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapseSeven">Is there a help resource for custom layouts?</a>
                </h4>
            </div>
            <div id="collapseSeven" class="panel-collapse collapse">
                <div class="panel-body">
                    <p>Feel free to file a report for help on layouts.</p>
                </div>
            </div>
        </div>
        <div class="panel panel-default">
            <div class="panel-heading">
                <h4 class="panel-title">
                    <a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapseThree">Do I have to use Placeholders when customizing my profile?</a>
                </h4>
            </div>
            <div id="collapseThree" class="panel-collapse collapse">
                <div class="panel-body">
                    Not at all. RPG offers customizable profiles to our members is to allow them full (yet safe) flexibility when creating their profiles. The placeholders are there for your convenience, but by no means do we suggest or expect for any placeholder to be used. If you have an idea for a placeholder, though, or a suggestion to make one of them better, please let us know!
                </div>
            </div>
        </div>
        <div class="panel panel-default">
            <div class="panel-heading">
                <h4 class="panel-title">
                    <a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapseSix">How do I block someone if they have a custom layout?</a>
                </h4>
            </div>
            <div id="collapseSix" class="panel-collapse collapse">
                <div class="panel-body">
                    <p>A character's custom layout can be disabled by adding the following string to the end of the user's URL. After the layout is disabled, the block button will become available.</p>
                    <pre>&disablecustom=1</pre>
                </div>
            </div>
        </div>
       
        <div class="panel panel-default">
            <div class="panel-heading">
                <h4 class="panel-title">
                    <a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapseEight">Why do I have to pay for uploading more than 12 images?</a>
                </h4>
            </div>
            <div id="collapseEight" class="panel-collapse collapse">
                <div class="panel-body">
                    <p>The Role-Players Guild is proud to say that while we may resize uploaded images, we strive to never destroy the quality of the images uploaded to our site. Unfortunately, the large number of high quality images can easily take up a lot of space in terms of data storage. We allow our users to upload up to 12 images for each character, but if they want to upload more images, we ask that they contribute to the cost of the data storage.</p>
                    <p>It should also be noted that RPG considers ourselves a website for writers. While image galleries and editing may be a fun side to the Role-Play world, RPG does not consider them particularly necessary to the building of a writer's abilities. RPG members are also encouraged to use other free image hosting providers and link to them if they cannot afford <a href="/Memberships/" target="_blank">our paid memberships</a>.</p>
                </div>
            </div>
        </div>
        <div class="panel panel-default">
            <div class="panel-heading">
                <h4 class="panel-title">
                    <a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapseNine">How can I donate to RPG?</a>
                </h4>
            </div>
            <div id="collapseNine" class="panel-collapse collapse">
                <div class="panel-body">
                    <p>One way to show support for RPG is to send in donations or purchase a paid membership. If you are not logged in, you can make an anonymous donation. However, if you log in and make a donation, you will receive a Donation badge. Each of these badges allow you to change the color of the name of any one of your characters to green. Donations of $100 USD or higher receive Large Donation badges, allowing you to use a green name with a glow around it.</p>
                    <input type="hidden" name="custom" value="<%= CurrentUserID() %>">
                    <input type="hidden" name="cmd" value="_s-xclick">
                    <input type="hidden" name="hosted_button_id" value="D4UR4R8SFH79C">
                    <p>
                        <asp:Button ID="btnDonate" runat="server" Text="Donate via PayPal" PostBackUrl="https://www.paypal.com/cgi-bin/webscr" CssClass="btn btn-primary" />
                    </p>
                    <p>Otherwise, you can log in to <a href="/Memberships/" target="_blank">learn more about purchasing a paid membership</a>.</p>
                </div>
            </div>
        </div>
        <div class="panel panel-default">
            <div class="panel-heading">
                <h4 class="panel-title">
                    <a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo">I saw an error! What do I do?!</a>
                </h4>
            </div>
            <div id="collapseTwo" class="panel-collapse collapse">
                <div class="panel-body">
                    Tell Us! <a href="/Report/">Submit a report</a> and include steps on what happened. If you can include screenshots of the problem, please add the links to those. If we need more information, we will contact you via a private thread.
                </div>
            </div>
        </div>
    </div>
</asp:Content>
